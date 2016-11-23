class Ticker
  def self.tick
    print "."
    @count += 1
  end

  def self.start(&block)
    @count = 0
    instance_eval(&block)
    @count
  end
end
