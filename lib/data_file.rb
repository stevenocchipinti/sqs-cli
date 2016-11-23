require 'ostruct'

class DataFile
  def initialize(filename)
    @filename = filename
  end

  def read_batches
    count = 0
    File.readlines(@filename).each_slice(10).each do |batch|
      yield (batch.map { |message|
        count += 1
        OpenStruct.new(message_id: count.to_s, body: message)
      })
    end
  end

  def write_batch(batch)
    File.open(@filename, "a") do |f|
      batch.each do |message|
        f.puts message.body
      end
    end
  end
end
