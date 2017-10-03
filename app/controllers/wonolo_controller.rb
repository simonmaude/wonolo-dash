class WonoloController < ApplicationController
  def index
    data =  StoredDatum.find(1)
    @completed_count = data.completed_count
    @in_progress_count = data.in_progress_count
    @no_show_count = data.no_show_count
    @cancelled_count = data.cancelled_count
    @timelineData = data.timelineData
    puts @timelineData
    @chartsArray = data.charts
    
  end
  
  def completed
    @completed_count, @empStatesComp = Won_api.this_Month_Jobs('completed')
    StoredDatum.updateCompletedCount(@completed_count)
    render :json => @completed_count
    
  end
  
  
  def in_progress
    @in_progress_count, @empStatesInProg = Won_api.this_Month_Jobs('in_progress')
    StoredDatum.updateInProgressCount(@in_progress_count)
    render :json => @in_progress_count
  
  end
  
  
  def no_show
    @no_show_count, @empStatesNoShow = Won_api.this_Month_Jobs('no_show')
    StoredDatum.updateNoShowCount(@no_show_count)
    render :json => @no_show_count
  
  end
  
  
  def cancelled
    @cancelled_count, @empStatesCanc = Won_api.this_Month_Jobs('cancelled')
    StoredDatum.updateCancelledCount(@cancelled_count)
    render :json => @cancelled_count
  
  end
  
  
  def timeline
    @timelineData = Won_api.getNextCompletes(1, 5)
    StoredDatum.updateTimelineData(@timelineData)
    render :json => @timelineData
  
  end
  
  
  def charts
    @completed_count, empStatesComp = Won_api.this_Month_Jobs('completed')
    @in_progress_count, empStatesInProg = Won_api.this_Month_Jobs('in_progress')
    @categoryComp = Won_api.this_Month_Jobs('completed', true)
    @categoryInProg = Won_api.this_Month_Jobs('in_progress', true)
    
    returnArrayPart1 = sort_chart_data(empStatesComp, empStatesInProg)
    returnArrayPart2 = sort_chart_data(@categoryComp, @categoryInProg)
    @chartsArray = [returnArrayPart1, returnArrayPart2]
    
    StoredDatum.updateChartsData(@chartsArray)
    
    render :json => @chartsArray
    
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
  
  
end

  