class CreateFeelings < ActiveRecord::Migration
  def change
    create_table :feelings do |t|
      t.integer :mission_id
      t.text :content
      t.string :day_name
      # 无需创建日期字段，从created_at获取即可
      
      t.timestamps
    end
  end
end
