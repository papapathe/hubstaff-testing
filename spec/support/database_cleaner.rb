# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, except: %w[ar_internal_metadata])
  end

  config.before do
    DatabaseCleaner.strategy = :transaction
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
