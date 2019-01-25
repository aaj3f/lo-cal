class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime  :date_and_time
      t.string  :location
      t.string  :organizer  #could later add Organizer model and make this a foreign-id
      t.string :description
    end
  end
end
