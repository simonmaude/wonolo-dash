class WonoloController < ApplicationController
  def index
    session[:timeline] = Won_api.getNextCompletes(1, 5) 
    @timelineData = session[:timeline]

  end
  
  def completed
    @completed_count = StoredJob.getCount("completed")
    # @completed_count, @empStatesComp = Won_api.this_Month_Jobs('completed')
    # @avgCompTimes = Won_api.this_Month_Jobs('completed')
    render :json => @completed_count
    
  end
  
  
  def in_progress
    @in_progress_count = StoredJob.getCount("in_progress")
    # @in_progress_count, @empStatesInProg = Won_api.this_Month_Jobs('in_progress')
    render :json => @in_progress_count
  
  end
  
  
  def no_show
    @no_show_count = StoredJob.getCount("no_show")
    # @no_show_count, @empStatesNoShow = Won_api.this_Month_Jobs('no_show')
    render :json => @no_show_count
  
  end
  
  
  def cancelled
    @cancelled_count = StoredJob.getCount("cancelled")
    # @cancelled_count, @empStatesCanc = Won_api.this_Month_Jobs('cancelled')
    render :json => @cancelled_count
  
  end
  
  
  # def timeline(page_num)
  #   @timelineData = Won_api.getNextCompletes(page_num, 5)
  #   render :json => @timelineData
  
  # end
  
  
  def charts
    # @completed_count, empStatesComp = Won_api.this_Month_Jobs('completed')
    puts ("*" * 40) 
    @empStates = StoredJob.getStates()
    @categories = StoredJobRequest.getCategory()
    
    
    # returnArrayPart1 = sort_chart_data(@empStates, empStatesInProg)
    # returnArrayPart2 = sort_chart_data(@categories, @categoryInProg)
    
    render :json => [@empState, @categories]
    
  end
  
  
  def sort_chart_data(hashOne, hashTwo)
    
    hashOne.keys.each do |state1|
      unless hashTwo.key?(state1)
        hashTwo[state1] = 0
      end
    end    
    
    hashTwo.keys.each do |state1|
      unless hashOne.key?(state1)
        hashOne[state1] = 0
      end
    end
    
    states, hashOneValues = hashOne.sort_by { |state, count| state.to_s }.transpose
    states, hashTwoValues = hashTwo.sort_by { |state, count| state.to_s }.transpose
    
    [states, hashOneValues, hashTwoValues]
  end
  
  
  def updateData
    StoredJob.updateData()
    StoredJobRequest.updateData()
  
  end
  
  
end

  