class CreateStoredData < ActiveRecord::Migration
  def change
    create_table :stored_data do |t|
      t.integer :completed_count
      t.integer :in_progress_count
      t.integer :no_show_count
      t.integer :cancelled_count
      t.text :charts
      t.text :timelineData

      t.timestamps null: false
    end
  end
end
