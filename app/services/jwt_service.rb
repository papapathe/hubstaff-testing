# frozen_string_literal: true

# Encodes and decodes a jwt token
class JwtService
  # encodes a user payload to jwt format
  #
  # @param user [User] the logged in user
  # @param algorithm [String] the algorithm to use when signing jwt
  # @param secret [String] the jwt secret
  def encode(user:, algorithm:, secret:)
    JWT.encode(
      { user_id: user.id, last_login_secret: user.last_login_secret },
      secret,
      algorithm
    )
  end

  # Decodes a jwt token
  # @param jwt_string [String]
  # @param secret [String]
  # @param decoding_options [String]
  def decode(jwt_string, secret, decode_options)
    JWT.decode jwt_string, secret, decode_options
  end
end
