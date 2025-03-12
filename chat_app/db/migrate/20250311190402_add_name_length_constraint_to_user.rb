class AddNameLengthConstraintToUser < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :name, :string, limit: 6
  end
end
