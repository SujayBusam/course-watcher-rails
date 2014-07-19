require 'rubygems'
require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'
require 'heroku-api'

include Clockwork



# handler do |job|
#   puts "Running #{job}"
# end

# puts "testing clockwork"

heroku = Heroku::API.new(api_key: '764626c9-b48d-43a2-a71f-4b060c88fd13')
 
every(20.seconds, 'Update Attributes') do 
  heroku.post_ps_scale("coursewatch", "clock", 1)
  Course.update_attributes
  heroku.post_ps_scale("coursewatch", "clock", 0)
end