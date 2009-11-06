class MainController < Ramaze::Controller
  layout :default
  helper :xhtml
  engine :Erubis

  # pushes a new job onto the message queue
  def job
    @job_id = JOB_MANAGER.next_job_id
    JOB_MANAGER.enqueue(@job_id)
    Ramaze::Log.debug "started the job!"
  end
  
  # returns a JSON object for the AJAX request.
  # will wait for an update from the worker script for up to 60 seconds
  # before returning a response to the client request.
  def check_job_progress
    job_id = request["job_id"].to_i
    Ramaze::Log.debug "update requested for #{job_id}"
    
    # Look for job status updates for up to 60 seconds
    60.times do
      progress = JOB_MANAGER.query_status(job_id)

      # Return progress info only if we have a new update to report on
      if progress.nil?
        Ramaze::Log.debug "Waiting for data..."
        sleep 1
      else
        Ramaze::Log.debug "percent done: #{progress[:progress_percent].to_i}"
      
        # report status as finished when the job is completed
        if progress[:job_finish]
          return {:progress_text => "finished.", :progress_status => "finished"}.to_json

        # otherwise report the percent done as the job status 
        else
          return {:progress_text => progress[:progress_text].gsub(' ', '&nbsp;'), 
              :progress_status => progress[:progress_percent]}.to_json
        end
      end
    end

    Ramaze::Log.debug "(timeout waiting for job updates)"
    Ramaze::Log.warn "Is the job processor running?" 
    {:progress_text => 'waiting...(is the job processor running??)', :progress_status => "timeout"}.to_json
  end
  
end
