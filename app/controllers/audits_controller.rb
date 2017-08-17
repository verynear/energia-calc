class AuditsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_audit, except: [:clone, :create, :deleted, :index]

  helper_method :current_audit

  def index
     respond_to do |format|
       format.html do
        @audits = current_user.available_audits
                              .active
                              .includes(:audit_type, :audit_structure, :user)
                              .order(performed_on: :desc)
       end

      format.json do
        @audits = current_user.audits.active
        render json: @audits
      end
    end
  end

  def clone
    source_audit = current_user.available_audits.active.find(params[:source_audit_id])
    new_audit_params = params.require(:audit).permit(:name, :performed_on)
    AuditCloneService.execute!(params: new_audit_params,
                               source_audit: source_audit)
    redirect_to audits_path
  end

  def create
    respond_to do |format|
      format.html do
        AuditCreator.execute!(params: params, user: current_user)
        redirect_to audits_path
      end

      format.json do
        process_audit
      end
    end
  end

  def deleted
    @audits = current_user.available_audits.destroyed
  end

  def immediate_delete
    AuditDestroyer.execute(audit: @audit)
    flash[:notice] = "Permanently deleted audit '#{@audit.name}'"
    redirect_to deleted_audits_path
  end

  def update
    respond_to do |format|
      format.html do

      end

      format.json do
        process_audit
      end
    end
  end

  def show
    @substructure = AuditStructure.new(parent_structure: @audit.audit_structure)
    @sample_group = SampleGroup.new(parent_structure: @audit.audit_structure)
  end

  def destroy
    head 401 if mobile_device?

    if @audit.is_locked?
      flash[:error] = "'#{@audit.name}' cannot be deleted, it is locked by
        #{@audit.locked_by_user.full_name}"
      redirect_to audits_path
    else
      @audit.update_attribute(:destroy_attempt_on, Time.current)

      flash[:notice] = "'#{@audit.name}' has been marked for deletion"
      redirect_to audits_path
    end
  end

  def lock
    if @audit.is_locked? && @audit.locked_by_user != current_user
      render json: @audit, status: :unauthorized
    else
      @audit.locked_by_user = current_user
      @audit.save!
      render json: @audit, status: :ok
    end
  end

  def undelete
    @audit.update_attribute(:destroy_attempt_on, nil)
    redirect_to deleted_audits_path
  end

  def unlock
    if @audit.is_locked? && @audit.locked_by_user != current_user
      render json: @audit, status: :unauthorized
    else
      @audit.update_attribute(:locked_by, nil)
      render json: @audit, status: :ok
    end
  end

  private

  def audit_params
    params.require(:audit)
          .permit(:id,
                  :name,
                  :is_archived,
                  :performed_on,
                  :user_id,
                  :audit_structure_id,
                  :upload_attempt_on,
                  :successful_upload_on,
                  :audit_type_id,
                  :created_at,
                  :updated_at,
                  :locked_by,
                  :organization_id)
  end

  def audit_strc_type
    @audit_strc_type ||= AuditStrcType.find_by(name: 'Audit')
  end

  def process_audit
    find_or_create
    @audit.assign_attributes(audit_params)
    @audit.locked_by = nil
    if save_audit
      render json: @audit, status: :ok
    else
      render json: @audit.errors, status: :bad_request
    end
  end

  def save_audit
    if @audit.save
      @audit.update_attribute(:successful_upload_on, @audit.upload_attempt_on)
      return true
    end
    false
  end

  def find_or_create
    @audit = Audit.where(id: params[:id]).first
    return if @audit
    @audit = Audit.new
    @audit.id = params[:id]
  end

  def find_audit
    @audit = current_user.available_audits.find_by_id(params[:id])
    head :not_found unless @audit
  end

  def current_audit
    return nil unless params[:id]
    @audit ||= current_user.available_audits.find(params[:id])
  end
end
