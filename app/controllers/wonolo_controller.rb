class WonoloController < ApplicationController
  def index
    puts "running controller"
    @completed_count = Won_api.this_Month_Jobs('completed')
    @in_progress_count = Won_api.this_Month_Jobs('in_progress')
    @no_show_count = Won_api.this_Month_Jobs('no_show')
    @cancelled_count = Won_api.this_Month_Jobs('cancelled')
  
  
  end
end
  