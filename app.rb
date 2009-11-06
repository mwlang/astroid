require 'rubygems'
require 'ramaze'

Ramaze.setup do
  gem 'sequel'
  gem 'beanstalk-client'
  gem 'json'
end

ROOT_DIR = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift(File.join(ROOT_DIR, 'lib'))

Ramaze::acquire File.join(ROOT_DIR, 'lib', '*')

DB = Sequel.sqlite(File.join(ROOT_DIR, 'demo.db'))
BEANSTALK_QUEUE = Beanstalk::Pool.new(['0.0.0.0:11300'])
JOB_MANAGER = JobManager.new(DB)

require File.join(ROOT_DIR, 'controller', 'main')
