class VisitorsController < ApplicationController
  
  layout :determine_layout

  def index
    
  end

  private

    def determine_layout
      if user_signed_in?
        'application'
      else
        'public'
      end
    end
end
