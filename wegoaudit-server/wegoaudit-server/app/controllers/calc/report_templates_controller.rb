class Calc::ReportTemplatesController < SecuredController
  def create
    create_params = report_template_params.merge(
      organization_id: current_user.organization_id
    )
    @template = ReportTemplate.new(create_params)

    if @template.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def destroy
    @template = ReportTemplate.find(params[:id])
    @template.destroy

    redirect_to action: :index
  end

  def edit
    @page_title = 'Edit report template'
    @template = ReportTemplate.find(params[:id])
    @context = ReportTemplateContext.new(
      report_template: @template,
      user: current_user)
  end

  def index
    @page_title = 'View templates'
    @templates = ReportTemplate.all
  end

  def new
    @page_title = 'New report template'
    @template = ReportTemplate.new
    @context = ReportTemplateContext.new(
      report_template: @template,
      user: current_user)
  end

  def preview
    @template = ReportTemplate.new(report_template_params)
    @context = ReportTemplateContext.new(
      report_template: @template,
      user: current_user)
    render text: @context.preview_html
  end

  def update
    @template = ReportTemplate.find(params[:id])

    if @template.update(report_template_params)
      redirect_to action: :edit
    else
      render :edit
    end
  end

  private

  def report_template_params
    params.require(:report_template).permit(:markdown, :name, :layout)
  end
end
