class AddConstraintsToUsersEmailValidation < ActiveRecord::Migration[8.0]
  def change
    # Validar que o e-mail seja único
    add_index :users, :email, unique: true
  end
end
