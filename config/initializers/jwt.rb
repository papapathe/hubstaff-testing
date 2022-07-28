# frozen_string_literal: true

config = Rails.application.config_for(:jwt)
ConfigClass = Struct.new :secret, :algorithm
JwtConfig = ConfigClass.new(config[:secret], config[:algorithm])
