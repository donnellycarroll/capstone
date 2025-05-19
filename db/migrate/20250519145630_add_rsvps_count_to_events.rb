class AddRsvpsCountToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :rsvps_count, :integer, default: 0
  end
end
