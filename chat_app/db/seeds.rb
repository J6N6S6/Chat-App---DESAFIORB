# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Users para teste:
User.create!(name: "João123", email: "joao@a.com", password: "senha123")
User.create!(name: "Maria123", email: "maria@a.com", password: "senha123")
User.create!(name: "Pedroca", email: "pedro@a.com", password: "senha123")
