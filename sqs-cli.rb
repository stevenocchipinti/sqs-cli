require "aws-sdk"
require_relative "sqs"
require_relative "cli"

@sqs = SQS.new

all_queue_urls = Cli.wait_with_message("Fetching queues...") do
  @sqs.all_queues
end

source = Cli.prompt "Source",
  options: all_queue_urls,
  include_file: false

destination = Cli.prompt "Destination",
  options: all_queue_urls,
  include_file: false

delete = Cli.prompt "Delete message when processed?"

if source_url = source[:selected_option]

  count = 0
  @sqs.read_message_batches(source_url) do |batch|

    batch.each do |m|
      count += 1
      print "."
    end

    if destination_url = destination[:selected_option]
      @sqs.send_message_batches(destination_url, batch)
      @sqs.delete_message_batches(source_url, batch) if delete
    end

  end
  puts "\nProcessed #{count} messages"

end
