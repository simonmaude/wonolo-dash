class StoredJob < ActiveRecord::Base

  def self.updateData()
    states = ['completed', 'in_progress', 'no_show', 'cancelled']
    StoredJob.destroy_all
    states.each do |state|
      job_data = Won_api.this_Month_Jobs(state, false)
      StoredJob.create(job_data)
    end  
    
  end
  
  
  def self.getCount(state)
    StoredJob.where(job_state: state).count
  
  end
  
  
  def self.getStates(state)
    StoredJob.where(job_state: state).select(:worker_state, COUNT(:worker_state))
  end
  
  
end
