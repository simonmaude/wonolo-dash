class CreateStoredJobRequests < ActiveRecord::Migration
  def change
    create_table :stored_job_requests do |t|
      t.integer :job_id
      t.timestamp :completed_at
      t.timestamp :updated_at
      t.string :job_state
      t.string :category

      t.timestamps null: false
    end
  end
end
