# frozen_string_literal: true

# Base class for all controllers
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ApiError, with: :api_exception

  before_action :authenticate_with_token!

  private

  def authenticate_with_token!
    @current_user = Authenticator.new.authenticate!(request.headers['Authorization'])
  end

  def not_found
    render json: { error: 'Not Found' }, status: :not_found
  end

  def api_exception(error)
    render json: error.to_json, status: error.status
  end
end
