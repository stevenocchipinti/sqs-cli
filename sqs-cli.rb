require "aws-sdk"
require "inquirer"

sqs = Aws::SQS::Client.new

def wait_with_message(message)
  print message
  yield if block_given?
  print "\r\e[K"
end


# operations = [
#   "COPY all messages",
#   "MOVE all messages",
#   "DELETE all messages"
# ]

all_queue_urls = []
wait_with_message("Fetching queues...") do
  all_queue_urls = sqs.list_queues.queue_urls
end

source_queue_index = Ask.list "Source", all_queue_urls #+ ["FILE..."]
source_queue_url = all_queue_urls[source_queue_index]

# operation = Ask.list "Operation", operations

destination_queue_index = Ask.list "Destination", all_queue_urls #+ ["FILE..."]
destination_queue_url = all_queue_urls[destination_queue_index]


count = 0
loop do
  resp = sqs.receive_message(
    queue_url: source_queue_url,
    max_number_of_messages: 10
  )

  resp.messages.each do |m|
    count += 1
    print "."
  end

  break if resp.messages.empty?

  sqs.send_message_batch(
    queue_url: destination_queue_url,
    entries: resp.messages.map { |m|
      { id: m.message_id, message_body: m.body }
    }
  )

  sqs.delete_message_batch(
    queue_url: source_queue_url,
    entries: resp.messages.map { |m|
      { id: m.message_id, receipt_handle: m.receipt_handle }
    }
  )
end

puts "\nFound #{count} messages"
