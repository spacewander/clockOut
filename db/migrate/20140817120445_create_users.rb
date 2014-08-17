class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, default: "", null: false
      t.string :sex
      t.integer :year
      t.string :date
      t.string :password_hash, null: false
      t.string :salt
      t.date :join_date
      t.string :email, null: false
      t.date :last_actived
      t.integer :member_no

      t.timestamps
    end
  end
end
