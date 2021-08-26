# frozen_string_literal: true

# Base class for all controllers
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    render json: { error: 'Not Found' }, status: :not_found
  end
end
