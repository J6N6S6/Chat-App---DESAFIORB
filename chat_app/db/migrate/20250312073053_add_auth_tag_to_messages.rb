class AddAuthTagToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :auth_tag, :string
  end
end
