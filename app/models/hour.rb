class Hour < ActiveRecord::Base
  belongs_to :timecard
  has_many :historical_hours
  
  validate :format_of_datetimes
  validates_presence_of :description, :message=>"Description: Field is required"
  validates_presence_of :initial_time, :message=>"Initial Time: Field is required"
  validates_presence_of :end_time, :message=>"End Time: Field is required"
  validates_presence_of :timecard, :message=>"Timecard: Field is required"
  validate :uniqueness_of_timeframes
  validate :ranges_of_dates
  
  attr_accessor :date
  attr_accessor :intime
  attr_accessor :entime
  
  def self.timecard_hours(timecard)
    hours = timecard.hours.order('initial_time ASC')
    hours_param = []
    hours.each do |hour|
      hour_hash = {}
      hour_hash[:id] = hour.id
      hour_hash[:initial_time] = hour.initial_time.strftime('%H:%M')
      hour_hash[:end_time] = hour.end_time.strftime('%H:%M')
      hour_hash[:date] = hour.initial_time.strftime('%m-%d-%Y')
      hour_hash[:description] = hour.description
      hour_hash[:total_hours] = (((hour.end_time - hour.initial_time)/3600)*100).to_i / 100
      hours_param << hour_hash
    end
    
    hours_param.to_jqgrid_json_hash([:id, :initial_time, :end_time, :date, :description, :total_hours], 1, 200, hours_param.length)
  end
  
  private
  # Does the validation for the dates
  def format_of_datetimes
    # if is a right date
    if(date.match(/^(0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01])[-](19|2\d)\d\d$/))
      if(intime.match(/^([01][0-9]|[2][0-3])[:]([0-5][0-9])$/))
        self.initial_time = DateTime.strptime("#{self.date} #{self.intime}", "%m-%d-%Y %H:%M") + 6.hours
      else
        self.errors.add(:initial_time, "Initial Time: Please, enter valid time value - hh:mm")
      end
      if(entime.match(/^([01][0-9]|[2][0-4])[:]([0-5][0-9])$/))
        self.end_time = DateTime.strptime("#{self.date} #{self.entime}", "%m-%d-%Y %H:%M") + 6.hours
      else
        self.errors.add(:initial_time, "Initial Time: Please, enter valid time value - hh:mm")
      end
    else
      self.errors.add(:initial_time, "Date: Please, enter valid date value - mm-dd-yyyy")
    end
  end
  
  # validates the uniqueness of the timeframes
  def uniqueness_of_timeframes
    if(self.initial_time && self.end_time && timecard_id)
      #checks that there isn't any additional hour at the same time
      existing_hours = Hour.includes(:timecard).where(["timecards.user_id = ? AND ((hours.initial_time >= ? AND hours.initial_time < ?) OR (hours.end_time > ? AND hours.end_time <= ?) OR (hours.initial_time <= ? AND hours.end_time >= ?))", self.timecard.user_id, self.initial_time,self.end_time,self.initial_time,self.end_time,self.initial_time,self.end_time])
      if(existing_hours.length > 0 && existing_hours.first.id != self.id)
        self.errors.add(:initial_time, "Oops, you already have an hour registered within this timeframe.")
      end
    end
  end
  
  def ranges_of_dates
    if(self.initial_time && self.end_time && self.timecard)
      if(self.initial_time > self.end_time)
        self.errors.add(:end_time, "End time should be greater than initial time.")
      else
        if(self.timecard.initial_time > self.initial_time || self.timecard.end_time < self.end_time || self.timecard.end_time < self.initial_time)
          self.errors.add(:end_time, "Typed times aren't within timecard valid timeframe.")
        end
      end
    end
  end
end
