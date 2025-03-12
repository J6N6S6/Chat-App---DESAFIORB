require "openssl"
require "base64"

class Message < ApplicationRecord
  before_save :encrypt_content

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  has_one_attached :file

  validates :encrypted_content, presence: true
  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  # Define a chave de criptografia
  SECRET_KEY = [ Rails.application.credentials.encryption[:key] ].pack("H*")

  def encrypt_content
  return unless encrypted_content_changed?

  cipher = OpenSSL::Cipher::AES256.new(:GCM)
  cipher.encrypt
  cipher.key = SECRET_KEY
  iv = cipher.random_iv
  cipher.iv = iv

  encrypted = cipher.update(encrypted_content.to_s) + cipher.final
  self.encrypted_iv = Base64.strict_encode64(iv)
  self.encrypted_content = Base64.strict_encode64(encrypted)
  self.auth_tag = Base64.strict_encode64(cipher.auth_tag)
  end

  def decrypted_content
  return nil unless encrypted_content.present? && encrypted_iv.present? && auth_tag.present?

  decipher = OpenSSL::Cipher::AES256.new(:GCM)
  decipher.decrypt
  decipher.key = SECRET_KEY
  decipher.iv = Base64.decode64(encrypted_iv)
  decipher.auth_tag = Base64.decode64(auth_tag)

  encrypted_data = Base64.decode64(encrypted_content)
  decipher.update(encrypted_data) + decipher.final
  rescue OpenSSL::Cipher::CipherError
   "Erro ao descriptografar"
  end
end
