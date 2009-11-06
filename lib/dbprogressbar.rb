#
# Ruby/DBProgressBar - a text progress bar library
#
# Copyright (C) 2009 Michael Lang <mwlang@cybrains.net>
#     All rights reserved.
#     This is free software with ABSOLUTELY NO WARRANTY.
#
# You can redistribute it and/or modify it under the terms
# of Ruby's license.
#
require 'progressbar'

class DbProgressBar < ProgressBar

  def initialize (title, total, db_output)
    @db_output = db_output
    @progress_text = ''
    super(title, total)
  end

  def get_progress_text
    @db_output.progress_text
  end
  
  def get_progress_percent
    @db_output.progress_percent
  end
  
  private

  attr_reader :db_output
  attr_accessor :progress_text

  def get_width
    @terminal_width
  end

  def show
    arguments = @format_arguments.map {|method| 
      method = sprintf("fmt_%s", method)
      send(method)
    }
    @progress_text = sprintf(@format, *arguments)
    @db_output.post(progress_text, do_percentage, @finished_p)
    @previous_time = Time.now
  end

  public
  
  def clear
    @progress_text = ''
    @db_output.post(progress_text, 0, @finished_p)
  end
end

