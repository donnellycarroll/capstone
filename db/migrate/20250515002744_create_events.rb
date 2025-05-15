class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :image
      t.string :location
      t.string :description
      t.references :host, null: false, foreign_key: { to_table: :users}
      t.datetime :start_time
      t.datetime :end_time
      t.integer :rsvp_cap
      t.integer :guests_count, default: 0
      t.integer :comments_count, default: 0

      t.timestamps
    end
  end
end
