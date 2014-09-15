class AddLastClockOutToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :last_clock_out, :date
  end
end
