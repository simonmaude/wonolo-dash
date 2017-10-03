class StoredDatum < ActiveRecord::Base
    serialize :charts, Array
    serialize :timelineData, Array

    
    def self.updateCompletedCount(count)
        StoredDatum.update(1, completed_count: count)
    end
    
    def self.updateInProgressCount(count)
        StoredDatum.update(1, in_progress_count: count)
    end  
    
    def self.updateNoShowCount(count)
        StoredDatum.update(1, no_show_count: count)
    end
    
    def self.updateCancelledCount(count)
        StoredDatum.update(1, cancelled_count: count)
    end
    
    def self.updateTimelineData(data)
        StoredDatum.update(1, timelineData: data)
    end
    
    def self.updateChartsData(data)
        StoredDatum.update(1, charts: data)
    end
end
