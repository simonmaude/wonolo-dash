class RemoveCompletedAtCreatedAtFromStoredJobRequests < ActiveRecord::Migration
  def change
    remove_column :stored_job_requests, :completed_at, :datetime
    remove_column :stored_job_requests, :created_at, :datetime
  end
end
