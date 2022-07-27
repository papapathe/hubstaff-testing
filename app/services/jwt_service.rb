# frozen_string_literal: true

# Encodes and decodes a jwt token
class JwtService
  def encode(user:, algorithm:, secret:)
    JWT.encode(
      { user_id: user.id, last_login_secret: user.last_login_secret },
      secret,
      algorithm
    )
  end

  def decode(jwt_string, secret, decode_options)
    JWT.decode jwt_string, secret, decode_options
  end
end
