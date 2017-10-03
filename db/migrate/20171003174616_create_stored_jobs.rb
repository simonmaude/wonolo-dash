class CreateStoredJobs < ActiveRecord::Migration
  def change
    create_table :stored_jobs do |t|
      t.integer :job_id
      t.timestamp :completed_at
      t.timestamp :updated_at
      t.string :worker_first
      t.string :worker_second
      t.string :worker_avatar
      t.string :worker_state
      t.string :employer_name

      t.timestamps null: false
    end
  end
end
