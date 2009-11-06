# The Job manager enqueues jobs and tracks job queries
class JobManager 
  
  # prepares the last_queried hash and holds onto the db handle
  def initialize(db_handle)
    @last_queried = {}
    @dbh = db_handle
    unless @dbh.tables.include?(:progress_bars)
      Ramaze::Log.warn "No job queue! Is the job processor running?" 
    end
  end
  
  # returns the job status record from the database
  def get_job_status(job_id)
    @dbh[:progress_bars].filter(:id => job_id).first
  end
  
  # this demo just produces a random, yet to be used job_id
  def next_job_id
    new_id = rand(10*5)
    get_job_status(new_id).nil? ? new_id : next_job_id
  end
  
  # create a job status record here so that when there are lots of jobs pending
  # we can at least report the job is queued if the user comes along much later 
  # and resends request for a job status to the server.
  def create_job_record(job_id)
    if @dbh[:progress_bars].filter(:id => job_id).first
      @dbh[:progress_bars].filter(:id => job_id).
        update(:progress_text => 'queued...', 
          :progress_percent => 0,
          :job_start => Time.now,
          :last_updated => Time.now,
          :job_finish => nil)
    else
      @dbh[:progress_bars].
        insert(:id => job_id, 
          :progress_text => 'queued...', 
          :job_start => Time.now, 
          :last_updated => Time.now)
    end
  end
  
  # pushs the job_id onto the queue.
  def enqueue(job_id)
    create_job_record(job_id)
    BEANSTALK_QUEUE.yput(:job_id => job_id)
    @last_queried[job_id] = Time.now
  end
  
  # only return a status object if job finished or has changed since last queried
  # this is the secret to how we hold onto the client request until something 
  # meaningful comes across from the worker script.
  def query_status(job_id)
    job = get_job_status(job_id)
    if job && (job[:job_finish] || job[:last_updated] > @last_queried[job_id])
      @last_queried[job_id] = Time.now
      job
    else
      nil
    end
  end
  
end
    
  