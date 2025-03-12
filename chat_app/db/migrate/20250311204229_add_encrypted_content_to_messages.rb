class AddEncryptedContentToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :encrypted_content, :text
  end
end
