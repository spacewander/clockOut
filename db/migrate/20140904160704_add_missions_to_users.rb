class AddMissionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :created_missions, :integer, :default => 0
    add_column :users, :finished_missions, :integer, :default => 0
    add_column :users, :current_missions, :integer, :default => 0
  end
end
