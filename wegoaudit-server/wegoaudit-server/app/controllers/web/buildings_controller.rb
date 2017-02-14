module Web
  class BuildingsController < BaseController
    def search
      @buildings = Building.search_by_name(params[:q])
    end
  end
end
