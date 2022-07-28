# frozen_string_literal: true

# Encrypts a string using ActiveSupport::MessageEncryptor
class MessageEncryptorService
  attr_reader :encryptor, :message

  def initialize(message, salt: 'default salt', encryptor_base_key: 'default_base_key')
    @message = message
    @encryptor = ActiveSupport::MessageEncryptor.new(generate_key(encryptor_base_key, salt))
  end

  def encrypt
    encryptor.encrypt_and_sign(message)
  end

  def decrypt
    encryptor.decrypt_and_verify(message)
  end

  private

  def generate_key(encryptor_base_key, salt)
    ActiveSupport::KeyGenerator
      .new(encryptor_base_key)
      .generate_key(salt, ActiveSupport::MessageEncryptor.key_len.freeze)
  end
end
