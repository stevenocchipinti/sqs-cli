class Ticker
  attr_reader :count

  def initialize(count=0, opts={})
    @count = count
    @silent = opts.fetch(:silent, false)
    @start_time = Time.now
  end

  def increment
    print "." unless @silent
    @count += 1
  end

  def uptime
    @end_time = Time.now
    (@end_time - @start_time).round(2)
  end
end
