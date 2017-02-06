module Web
  class BuildingsController < BaseController
    def search
      @buildings = current_user.buildings.search_by_name(params[:q])
    end
  end
end
