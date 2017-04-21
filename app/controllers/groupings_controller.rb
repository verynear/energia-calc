class GroupingsController < SecuredController
  def index
    render json: Grouping.all
  end
end
