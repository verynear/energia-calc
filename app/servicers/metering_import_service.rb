class MeteringImportService < BaseServicer
  attr_accessor :meter,
                :params,
                :audit_structure,
                :user

  def execute!
    process_params
    if physical_structure_exists?
      create_or_update_metering
    else
      create_temporary_physical_structure
      create_or_update_metering
      enqueue_structure_retrieval
    end
  end

  private

  def physical_structure_exists?
    raise_development_error if params[:object_type] == 'Development'
    @physical_structure = object_class.find_by(wegowise_id: params[:wegowise_id],
                                               cloned: false)
  end

  def create_or_update_metering
    if metering_exists?
      @metering.update_attributes(physical_structure: @meter,
                                  parent_structure_id: @physical_structure.audit_structure,
                                  name: @meter.name)
    else
      @metering = AuditStructure.create(audit_strc_type: Meter.audit_strc_type,
                                   physical_structure: @meter,
                                   parent_structure_id: @physical_structure.audit_structure,
                                   name: @meter.name)
    end
  end

  def metering_exists?
    @metering = AuditStructure.find_by(physical_structure: @meter,
                                  parent_structure_id: @physical_structure.audit_structure.id)
    @metering
  end

  def create_temporary_physical_structure
    @physical_structure = structure_class.create_temporary!(params[:wegowise_id],
                                                            params[:name])

    AuditStructure.create!(audit_strc_type: structure_class.audit_strc_type,
                 name: params[:name],
                 physical_structure: @physical_structure)
  end

  def structure_class
    Module.const_get(params[:object_type])
  end

  def enqueue_structure_retrieval
    structure_retrieval_worker.perform_async(params[:wegowise_id],
                                             user.id)
  end

  def structure_retrieval_worker
    "#{params[:object_type]}RetrievalWorker".constantize
  end

  def process_params
    @params = WegoHash.new(@params)
  end

  def object_class
    params[:object_type].constantize
  end

  def raise_development_error
    raise 'Meterings cannot be created for developments'
  end
end
