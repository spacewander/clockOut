class CreateFeelings < ActiveRecord::Migration
  def change
    create_table :feelings do |t|
      t.integer :mission_id
      t.text :content
      t.string :day_name
      
      t.timestamps
    end
  end
end
