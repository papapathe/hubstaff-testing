# frozen_string_literal: true

module ControllerTestHelpers
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include ControllerTestHelpers, type: :controller
  config.include ActiveSupport::Testing::TimeHelpers, type: :controller
end
