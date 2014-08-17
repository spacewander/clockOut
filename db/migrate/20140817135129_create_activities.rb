class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name, :null => false, :default => ""
      t.integer :days, :null => false, :default => 30
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
      # 个人可以发起活动，但是发起的活动属于小组
      t.integer :group_id
      t.integer :creater # user_id

      t.integer :visited_count
      t.integer :participants_number
      t.timestamps
    end
  end
end
