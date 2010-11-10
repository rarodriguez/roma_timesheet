module ApplicationHelper
  def timecards_status_name status
    case status
    when PROCESS
      "Process"
    when REVISION
      "Revision"
    when REJECT
      "Rejected"
    when ACCEPT
      "Accepted"
    when FINISHED
      "Finished"
    else
      "New Timecard"
    end
  end
end
