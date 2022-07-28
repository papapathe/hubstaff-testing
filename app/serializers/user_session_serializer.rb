# frozen_string_literal: true

# Serialize the user as response to login request
class UserSessionSerializer
  include JSONAPI::Serializer

  # The unique name of the user
  attributes :name

  # The token that will be used to authenticate api requests
  attribute :token do |user|
    jwt = JwtService.new.encode(
      user: user,
      algorithm: JwtConfig.algorithm,
      secret: JwtConfig.secret
    )
    MessageEncryptorService.new(jwt).encrypt
  end
end
