class Hour < ActiveRecord::Base
  belongs_to :timecard
  has_many :historical_hours
  
  validate :datetimes
  validates_presence_of :description, :message=>"Description: Field is required"
  validates_presence_of :initial_time, :message=>"Initial Time: Field is required"
  validates_presence_of :end_time, :message=>"End Time: Field is required"
  validates_presence_of :timecard_id, :message=>"Timecard: Field is required"
  
  attr_accessor :date
  attr_accessor :intime
  attr_accessor :entime
  
  private
  # Does the validation for the dates
  def datetimes
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
end
