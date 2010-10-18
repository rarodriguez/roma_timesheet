class Timecard < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :current_timecards_note, :class=>"TimecardsNote"
  has_many :timecards_notes
  has_many :hours
  belongs_to :last_updater, :class_name => "User", :foreign_key=> 'last_update_by'
end
