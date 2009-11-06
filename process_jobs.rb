require 'rubygems'
require 'daemons'
require 'beanstalk-client' 
require 'sequel'

ROOT_DIR = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift(File.join(ROOT_DIR, 'lib'))

require 'dbprogressbar'
require 'sequel_output'

Daemons.run_proc('process_astroid_jobs', :log_output => true) do
  DB = Sequel.sqlite(File.join(ROOT_DIR, 'demo.db'))
  SequelOutput.prepare_database(DB)
  beanstalk = Beanstalk::Pool.new(["0.0.0.0:11300"])
  loop do
    job = beanstalk.reserve 
    jh = job.ybody
    total = 15
    puts "processing #{jh[:job_id]}"
    pbar = DbProgressBar.new("job ##{jh[:job_id]}", total, SequelOutput.new(jh[:job_id], DB))
    total.times do
      pbar.inc
      sleep(1)
    end
    pbar.finish
    puts "finished #{jh[:job_id]}"
    job.delete
  end
end
