desc "Update course attributes"
task update_course_attributes: :environment do

  require 'net/http'
  require 'nokogiri'
  require 'uri'

  # For each course, update attributes
  courses = Course.all
  courses.each do |course|  
    
    # Get all associated course selections
    course_selections = CourseSelection.where(course_id: course.id)

    unless course_selections.empty?
      post_data = { "classyear" => "2008", # Not sure why this is the case, but necessary for request
                  "subj" => "#{course.subject}",
                  "crsenum" => "#{course.number}" } 


      uri = URI.parse('http://oracle-www.dartmouth.edu/dart/groucho/timetable.course_quicksearch')
      response_body = (Net::HTTP.post_form(uri, post_data)).body
      response_body.delete!("\n") # Response body was littered with new lines
      page = Nokogiri::HTML(response_body)

      table = page.at_css('div.data-table')

      # Row currently before first section
      row = table.child.child.next

      # Move to correct row (section)
      course.section.to_i.times do
        row = row.next
      end

      # Table columns (nodes, not the text!)
      term = row.child
      crn = term.next
      subj = crn.next
      num = subj.next
      sec = num.next
      title = sec.next.next
      xlist = title.next
      period = xlist.next
      room = period.next
      building = room.next
      instructor = building.next
      wc = instructor.next
      dist = wc.next
      lim = dist.next
      enrl = lim.next
      status = enrl.next

      # Update course attributes
      course.update_attributes(instructor: Course.get_text(instructor),
                               limit: Course.get_text(lim),
                               enrollment: Course.get_text(enrl),
                               status: Course.get_text(status))

      # If the course is available
      if enrl.text.to_i < lim.text.to_i || lim.text.to_i == 0
        # Email user
      end

    end

  end

end