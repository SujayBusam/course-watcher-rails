class Course < ActiveRecord::Base
  require 'net/http'
  require 'nokogiri'
  require 'uri'

  # Database associations
  has_many :course_selections
  has_many :users, through: :course_selections

  validates :number, presence: true, numericality: { greater_than: 0 }
  validates :subject, uniqueness: { scope: [:number, :section] },
                      presence: true

  
  

  def available?
    self.limit == 0 || self.limit.nil? || self.enrollment < self.limit
  end

  def watched_by?(user)
    self.course_selections.find_by(user_id: user.id)
  end


  def self.validate_and_init(course_subject, course_number)
    
    post_data = { "classyear" => "2008", # Not sure why this is the case, but necessary for request
                "subj" => "#{course_subject}",
                "crsenum" => "#{course_number}" } 


    uri = URI.parse('http://oracle-www.dartmouth.edu/dart/groucho/timetable.course_quicksearch')
    response_body = (Net::HTTP.post_form(uri, post_data)).body
    response_body.delete!("\n")
    page = Nokogiri::HTML(response_body)

    table = page.at_css('div.data-table')

    # if there is no table or an empty table, the course is not a valid one
    return nil if table.nil? || (table.child.child.next).nil? 

    # Course is valid. Get the first (maybe only) section
    row = table.child.child.next.next

    course_set = Array.new

    while row
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
      course = Course.new(subject: course_subject, 
                         number: course_number,
                         instructor: self.get_text(instructor),
                         limit: self.get_text(lim),
                         enrollment: self.get_text(enrl),
                         status: self.get_text(status),
                         crn: self.get_text(crn),
                         section: self.get_text(sec),
                         title: self.get_text(title),
                         cross_list: self.get_text(xlist),
                         period: self.get_text(period),
                         building: self.get_text(building),
                         world_culture: self.get_text(wc),
                         distrib: self.get_text(dist))
      course.save

      # # If the course is available
      # if course.available?
      #   # Email user
      # end

      course_set.push(course)

      # Go to next row (course section)
      row = row.next
    end

    return course_set
  end


  private

    # private helper function for initializer
    def self.get_text(node)
      text = node.text
      if text.nil? || text.empty? || text == "&nbsp"
        return nil
      else
        return text
      end
    end

end
