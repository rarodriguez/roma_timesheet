module TimecardsHelper
  def timecards_notes_list(timecards_notes)
    result = "<ul>"
    timecards_notes.each do |note|
      result << "<li><div>Changed from <b>'#{timecards_status_name(note.old_status)}'</b> to <b>'#{timecards_status_name(note.current_status)}'</b> <br/> On #{note.created_at.strftime('%A %d, %Y at %H:%M')}."
      result << "#{note.creator.name} #{note.creator.last_name}" if(note.creator)
      #if(note.justification && note.justification)
        result << "<br />"
        result << "<span style='font-size:0.9em;'>#{note.justification}</span>"
      #end
      result << "</div></li>"
    end
    result << "</ul>"
    result.html_safe
  end
end
