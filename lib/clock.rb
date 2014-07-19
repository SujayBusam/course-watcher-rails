require 'rubygems'
require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'
include Clockwork



# handler do |job|
#   puts "Running #{job}"
# end

# puts "testing clockwork"
 
every(5.minutes, 'Update Attributes') { Course.update_attributes }