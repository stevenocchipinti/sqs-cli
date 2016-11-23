require 'ostruct'
require 'base64'

class DataFile
  def initialize(filename)
    @filename = filename
  end

  def read_batches
    count = 0
    File.readlines(@filename).each_slice(10).each do |batch|
      yield (batch.map { |message|
        count += 1
        OpenStruct.new(
          message_id: count.to_s,
          body: Base64.strict_decode64(message.strip)
        )
      })
    end
  end

  def write_batch(batch)
    File.open(@filename, "a") do |f|
      batch.each do |message|
        f.puts Base64.strict_encode64(message.body.strip)
      end
    end
  end
end
