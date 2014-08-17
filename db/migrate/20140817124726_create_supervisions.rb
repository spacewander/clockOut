class CreateSupervisions < ActiveRecord::Migration
  def change
    create_table :supervisions do |t|
      t.integer :user_id
      t.integer :mission_id

      t.timestamps
    end
  end
end
