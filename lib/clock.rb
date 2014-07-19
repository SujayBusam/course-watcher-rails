require 'rubygems'
# require File.expand_path('../../config/boot',        __FILE__)
# require File.expand_path('../../config/environment', __FILE__)
require './config/boot'
require './config/environment'
require 'clockwork'
require 'heroku-api'

include Clockwork



# handler do |job|
#   puts "Running #{job}"
# end

# puts "testing clockwork"


every(20.seconds, 'Update Attributes') do
  Course.update_attributes
end