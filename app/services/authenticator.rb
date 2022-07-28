# frozen_string_literal: true

# Performs jwt token based authentication
class Authenticator
  # authenticates a user from a token.
  #
  # @param token [string] a jwt token encrypted with ActiveSupport::MessageEncryptor
  # @param encryptor [MessageEncryptorService] the service used to decrypt the jwt
  # @param jwt_swc [JwtService] the service used to decode the jwt
  #
  # @raise ArgumentError, ActiveRecord::RecordNotFound
  def authenticate!(token, encryptor: MessageEncryptorService, jwt_svc: JwtService.new)
    raise ApiError.new 'Authorization header is not present', 401 if token.blank?

    jwt_string = encryptor.new(token).decrypt

    data, = jwt_svc.decode jwt_string, JwtConfig.secret, { algorithm: JwtConfig.algorithm }

    user = User.find(data['user_id'])

    raise ArgumentError unless user.last_login_secret == data['last_login_secret']

    user
  end
end
