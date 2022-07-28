# frozen_string_literal: true

# Holds all the business logic related to user login
class SessionService
  MESSAGE = 'invalid credentials'

  # @param params [ActionController::Parameters] user input from controller
  # @raise ApiError
  def create!(params)
    user = User.find_by name: params[:name]

    raise ApiError, MESSAGE if user.blank?

    raise ApiError, MESSAGE unless user.authenticate(params[:password])

    user
  end
end
