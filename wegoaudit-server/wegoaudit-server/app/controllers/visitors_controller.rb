class VisitorsController < ApplicationController
  layout 'public'

  def index
    redirect_to audits_path if user_signed_in?
  end
end
