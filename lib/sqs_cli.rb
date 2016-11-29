require "inquirer"
require_relative "sqs_cli/sqs"
require_relative "sqs_cli/cli"
require_relative "sqs_cli/ticker"
require_relative "sqs_cli/data_file"

module SqsCli
  extend self

  def run
    all_queue_urls = Cli.wait_with_message("Fetching queues...") do
      SQS.all_queues
    end

    source = Cli.list_options "Source queue or file",
      all_queue_urls,
      include_file: true
    source_is_queue = source[:selected_item]

    destination = Cli.list_options "Destination queue or file (appends)",
      all_queue_urls,
      include_file: source_is_queue,
      include_stdout: source_is_queue

    if source_is_queue
      delete_when_done = Ask.confirm "Delete message when processed?"
    end


    ticker = Ticker.new

    if source_url = source[:selected_item]
      SQS.read_message_batches(source_url) do |batch|
        batch.each { ticker.increment }

        if destination_url = destination[:selected_item]
          SQS.send_message_batch(destination_url, batch)
        elsif destination_file = destination[:filename]
          DataFile.new(destination_file).write_batch(batch)
        elsif stream = destination[:stream]
          batch.each { |message| stream.puts message.body }
        end

        SQS.delete_message_batch(source_url, batch) if delete_when_done
      end

    elsif source_file = source[:filename]
      DataFile.new(source_file).read_batches do |batch|
        batch.each { ticker.increment }

        if destination_url = destination[:selected_item]
          SQS.send_message_batch(destination_url, batch)
        end
      end
    end

    puts "\nProcessed #{ticker.count} messages in #{ticker.uptime} seconds"
  end
end
