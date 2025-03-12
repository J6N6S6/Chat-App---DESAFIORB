class AddEncryptedIvToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :encrypted_iv, :string
  end
end
