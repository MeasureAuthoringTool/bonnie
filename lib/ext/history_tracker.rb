# Create a new class to track histories. All histories are stored in this tracker.
# Required by the mongiod-history gem
class HistoryTracker
  include Mongoid::History::Tracker
end
