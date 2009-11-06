== README

Astroid (not Astroids) is my hat-tip to Pistos' Comet example.  This project demonstrates how to perform long-running processes in an environment where you're going to want to manage the job processor scripts and message queue server in your daemonized environment. 

I was a little bored so I forked the ruby-progressbar project and extended with a db-progressbar.  The original comes from Satoru Takabayashi, but I found a newer version on github, apparently maintained by Nathan Weizenbaum.  The latter source was whence I forked my version.

Other bonus points include demonstration of jQuery, JSON-based AJAX requests, and the fantastic Ramaze and Ruby Sequel projects.

== Credits
  * Pistos' Comet blog: http://blog.purepistos.net/index.php/2009/01/27/comet-with-ramaze/
  * Topfunky's beanstalk blog: http://nubyonrails.com/articles/about-this-blog-beanstalk-messaging-queue
  * http://nubyonrails.com/articles/about-this-blog-beanstalk-messaging-queue
  * ProgressBar: 
		* Satoru Takabayashi:  http://0xcc.net/ruby-progressbar/ 
		* Nathan Weizenbaum:   http://github.com/nex3/ruby-progressbar

0. Install Ruby

1. Install beanstalkd

2. Install these gems:  
	- daemons 
	- ramaze
	- json
	- sequel
	- beanstalk-client
	
3. Start a new terminal window and run beanstalkd with:
	beanstalkd -l 0.0.0.0 -p 11300
		(to see output at terminal)

4. Start a new terminal window and run process_jobs.rb with:
	ruby process_jobs run
	  (to see output at terminal)

5. Start the Ramaze application with:
	ramaze start

	
Once you know you have a running environment, then give it a shot fully daemonized:

3b.  Stop beanstalkd with Ctrl-C and run with:
	beanstalkd -d -l 0.0.0.0 -p 11300
	
4b.  Stop with Ctrl-C and run with:
	ruby process_jobs.rb start

5b.  Fire up the Ramaze application under your favorite web server.

