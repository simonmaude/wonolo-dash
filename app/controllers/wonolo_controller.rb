class WonoloController < ApplicationController
  def index
    @completed_count, @empStatesComp = Won_api.this_Month_Jobs('completed')
    @in_progress_count, @empStatesInProg = Won_api.this_Month_Jobs('in_progress')
    @no_show_count = Won_api.this_Month_Jobs('no_show')
    @cancelled_count = Won_api.this_Month_Jobs('cancelled')
    
    @avgCompTimes = Won_api.this_Month_Jobs('completed')
    
    @empStatesComp.keys do |state1|
      if !@empStatesInProg.include? state1
        @empStatesInProg[state1] = 0
      end
    end
        
    @empStatesInProg.keys do |state2|
      if !@empStatesComp.include? state2
        @empStatesInComp[state2] = 0
      end
    end
    
    @states = @empStatesInProg.keys
    puts "array"
    puts @states
  
  end
end
  