require File.expand_path('app', File.dirname(__FILE__))

Ramaze::Controller.trait :needs_method => true

# Using mongrel because it shuts down faster when debugging and we want to stop 
# the 60.times loop in the main controller
Ramaze.start(:adapter => :mongrel, :port => 7000, :file => __FILE__)
