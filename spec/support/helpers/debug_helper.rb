module DebugHelper
  # Makes p() more visible in log feed
  def p_loud(object, msg=nil)
    p ''
    p '----------------<p_loud begins>----------------'
    if msg 
      p msg
    end
    p ''
    p object
    p ''
    p '-----------------<p_loud ends>-----------------'
    p ''
  end

  # Makes p() more visible, but less so than p_loud()
  def p_mild(object, msg=nil)
    p ''
    if msg 
      p msg
    end
    p object
    p ''
  end
end