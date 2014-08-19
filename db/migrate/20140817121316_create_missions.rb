class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
      t.string :name, :null => false, :default => ""
      t.integer :days, :null => false, :default => 30
      # 无需创建日期字段，从created_at获取即可
      t.integer :finished_days
      t.integer :missed_days
      t.integer :missed_limit, :null => false, :default => 10
      # 连续没有打卡的天数
      t.integer :drop_out_days
      # 能够容忍的连续没有打卡的天数
      t.integer :drop_out_limit, :null => false, :default => 5
      t.text :content
      t.boolean :finished, :null => false, :default => false
      t.boolean :aborted, :null => false, :default => false
      t.boolean :public, :null => false, :default => false
      t.integer :user_id
      t.boolean :supervised, :null => false, :default => false

      t.timestamps
    end
  end
end
