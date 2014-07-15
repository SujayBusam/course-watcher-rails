module CourseSelectionsHelper

  require 'net/http'
  require 'nokogiri'
  require 'uri'

  def initialize_course(course)
      
    post_data = { "classyear" => "2008", # Not sure why this is the case, but necessary for request
                "subj" => "#{course.subject}",
                "crsenum" => "#{course.number}" } 


    uri = URI.parse('http://oracle-www.dartmouth.edu/dart/groucho/timetable.course_quicksearch')
    response_body = (Net::HTTP.post_form(uri, post_data)).body
    response_body.delete!("\n")
    page = Nokogiri::HTML(response_body)

    table = page.at_css('div.data-table')

    # if table.child.child.next is valid. In other words, is there a row there, or
    # only the header of the table?
    row = table.child.child.next.next

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
    course.update_attributes(instructor: instructor.text,
                             limit: lim.text,
                             enrollment: enrl.text,
                             status: status.text,
                             crn: crn.text,
                             section: sec.text,
                             title: title.text,
                             cross_list: xlist.text,
                             period: period.text,
                             building: building.text,
                             world_culture: wc.text,
                             distrib: dist.text)

    # If the course is available
    if enrl.text.to_i < lim.text.to_i || lim.text.to_i == 0
      # Email user
    end

  end
end