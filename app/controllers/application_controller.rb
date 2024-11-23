class ApplicationController < ActionController::API
  include Secured

  private
    def current_user
      @current_user || request.env[:current_user]
    end
end
