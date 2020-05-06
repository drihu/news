require 'time_difference'

module Helper
  # Takes a time object and returns how much time has passed
  # since that provided time as a humanized string.
  # test_time = Time.now - (60 * 5) # 5 minutes ago
  # "#{time_since_in_words(test_time)} ago"
  def time_since_in_words(date)
    TimeDifference.between(date, Time.now).humanize
  end
end
