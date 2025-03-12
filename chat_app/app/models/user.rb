class User < ApplicationRecord
    has_secure_password
    validates :email, presence: true, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "E-mail inválido" }
    validates :name, presence: true, length: { minimum: 6 }
end
