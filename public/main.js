
function check_progress() {
	job_progress_element = $('#job-progress');
	$.getJSON('/check_job_progress', {job_id: job_progress_element.attr('value')}, 
	  function(data){
	    job_progress_element.html(data.progress_text);
      	if (data.progress_status != "finished") check_progress();
	});
}

$(document).ready(function() {
	if($('#job-progress').length) check_progress();
});