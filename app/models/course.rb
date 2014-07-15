class Course < ActiveRecord::Base
  # Database associations
  has_many :course_selections
  has_many :users, through: :course_selections

  validates :number, presence: true, numericality: { greater_than: 0 }
  validates :subject, uniqueness: { scope: :number },
                      presence: true

  
  def Course.validate_and_init(user, course_subject, course_number)
    require 'net/http'
    require 'nokogiri'
    require 'uri'
    
    post_data = { "classyear" => "2008", # Not sure why this is the case, but necessary for request
                "subj" => "#{course_subject}",
                "crsenum" => "#{course_number}" } 


    uri = URI.parse('http://oracle-www.dartmouth.edu/dart/groucho/timetable.course_quicksearch')
    response_body = (Net::HTTP.post_form(uri, post_data)).body
    response_body.delete!("\n")
    page = Nokogiri::HTML(response_body)

    table = page.at_css('div.data-table')

    # if table.child.child.next is valid. In other words, is there a row there, or
    # only the header of the table?
    return nil if table.nil? || (table.child.child.next).nil? 

    # Course is valid
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

    # Initialize course and its attributes
    course = user.courses.create(subject: course_subject, 
                                 number: course_number,
                                 instructor: Course.get_text(instructor),
                                 limit: Course.get_text(lim),
                                 enrollment: Course.get_text(enrl),
                                 status: Course.get_text(status),
                                 crn: Course.get_text(crn),
                                 section: Course.get_text(sec),
                                 title: Course.get_text(title),
                                 cross_list: Course.get_text(xlist),
                                 period: Course.get_text(period),
                                 building: Course.get_text(building),
                                 world_culture: Course.get_text(wc),
                                 distrib: Course.get_text(dist))

    # # If the course is available
    # if enrl.text.to_i < lim.text.to_i || lim.text.to_i == 0
    #   # Email user
    # end

    return course
  end

  def available?
    self.limit == 0 || self.limit.nil? || self.enrollment < self.limit
  end

  def watched_by?(user)
    self.course_selections.find_by(user_id: user.id)
  end


  private

    # private helper function for initializer
    def Course.get_text(node)
      text = node.text
      if text.nil? || text.empty? || text == "&nbsp"
        return nil
      else
        return text
      end
    end

end
