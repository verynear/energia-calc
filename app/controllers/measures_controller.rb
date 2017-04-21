class MeasuresController < SecuredController
  def index
    @measures = Measure.all
    respond_to do |format|
      format.json do
        render json: @measures
      end
    end
  end
end
