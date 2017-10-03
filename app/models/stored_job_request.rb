class StoredJobRequest < ActiveRecord::Base

  def self.updateData()
    states = ['completed', 'in_progress', 'no_show', 'cancelled']
    StoredJobRequest.destroy_all
    states.each do |state| 
      job_request_data = Won_api.this_Month_Jobs(state, true)
      StoredJobRequest.create(job_request_data)
    end
    
  end
  
  
  def self.getCount(state)
    StoredJobRequest.where(job_state: state).count
  
  end
    
  
  def self.getCategory(state)
    StoredJobRequest.where(job_state: state).select(:category, COUNT(:category))
  end
  
end
