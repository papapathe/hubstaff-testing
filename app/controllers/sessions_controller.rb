# frozen_string_literal: true

# Handles user session creation
class SessionsController < ApplicationController
  skip_before_action :authenticate_with_token!, only: %i[create]

  def create
    user = SessionService.new.create!(params)
    render json: UserSessionSerializer.new(user).serializable_hash, status: :created
  end
end
