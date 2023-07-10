class AddIsAGuideToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_a_guide, :boolean, default: false
  end
end
