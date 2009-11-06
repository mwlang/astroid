class BaseOutput
  def post(progress_text, percentage)
    raise "BaseOutput#puts:  abstract method not implemented"
  end
end