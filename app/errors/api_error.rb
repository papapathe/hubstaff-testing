# frozen_string_literal: true

# Base class for errors raised while processing http requests
# The error is rescued at the controller level so we are safe when
# errors of this class or subclasses will be handled gracefully.
class ApiError < ::StandardError
  attr_reader :status

  # @param message [String] a message to describe the request
  # @param status [Integer] the http status to send in the response
  #  when the exception is rescued.
  def initialize(message, status = 401)
    super()
    @message = message
    @status = status
  end

  def to_json(*)
    {
      error: @message
    }
  end
end
