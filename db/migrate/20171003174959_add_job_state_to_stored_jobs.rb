class AddJobStateToStoredJobs < ActiveRecord::Migration
  def change
    add_column :stored_jobs, :job_state, :string
  end
end
