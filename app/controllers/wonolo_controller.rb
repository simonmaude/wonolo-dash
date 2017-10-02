class WonoloController < ApplicationController
  def index
  end
  
  def completed
    @completed_count, @empStatesComp = Won_api.this_Month_Jobs('completed')
    # @avgCompTimes = Won_api.this_Month_Jobs('completed')
    render :json => @completed_count
    
  end
  
  def in_progress
    @in_progress_count, @empStatesInProg = Won_api.this_Month_Jobs('in_progress')
    render :json => @in_progress_count
  
  end
  
  def no_show
    @no_show_count = Won_api.this_Month_Jobs('no_show')
    render :json => @no_show_count
    
  end
  
  def cancelled
    puts "cancelled received"
    @cancelled_count = Won_api.this_Month_Jobs('cancelled')
    puts @cancelled_count
    render :json => @cancelled_count
    
  end
  
  def charts
    @completed_count, @empStatesComp = Won_api.this_Month_Jobs('completed')
    @in_progress_count, @empStatesInProg = Won_api.this_Month_Jobs('in_progress')
    @empStatesComp.keys.each do |state1|
      unless @empStatesInProg.key?(state1)
        @empStatesInProg[state1] = 0
      end
    end
        
    @empStatesInProg.keys.each do |state2|
      unless @empStatesComp.key?(state2)
        @empStatesComp[state2] = 0
      end
    end
    
    @states = @empStatesInProg.keys
    @empStatesCompValues = @empStatesComp.values
    @empStatesInProgValues = @empStatesInProg.values
    returnArray = [@states, @empStatesCompValues, @empStatesInProgValues]
    
    render :json => returnArray
    
  end
  
  
end

  