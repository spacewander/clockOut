class CreateParticipantions < ActiveRecord::Migration
  def change
    create_table :participantions do |t|
      t.integer :user_id
      t.integer :activity_id

      t.timestamps
    end
  end
end
