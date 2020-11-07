module BlogpostsHelper
  def format_time(time)
    now = Time.now
    diff = (now - time)/60/60/24/4  # in units of 4 days

    # more than 4 days
    if diff >= 1
      return time.strftime("%-d %b %Y")   # ex: '3 Sep 2020'
    end

    # 24 hours to just under 4 days
    diff *= 4   # in units of single days
    if diff >= 1
      return diff.round.to_s + "d"      # ex: 3d
    end

    # 1 hour to just under 24 hours
    diff *= 24  # in units of single hours
    if diff >= 1
      return diff.round.to_s + "h"      # ex: '23h'
    end

    # 1 min to 1 hour
    diff *= 60  # in units of single minutes
    if diff >= 1
      return diff.round.to_s + "min"    # ex: '59min'
    end

    # less than 1 min
    diff *= 60  # in units of single seconds
    diff.round.to_s + "sec"               # ex: '59sec'
  end
end
