class CreateRsvps < ActiveRecord::Migration
  def change
    create_table :rsvps do |t|
      t.string :status
      t.integer :user_id
      t.integer :event_id
    end
  end
end
