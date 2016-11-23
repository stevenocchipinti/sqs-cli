module SQS
  extend self

  def all_queues
    sqs.list_queues.queue_urls
  end

  def read_message_batches(queue_url, &block)
    loop do
      resp = sqs.receive_message(
        queue_url: queue_url,
        max_number_of_messages: 10
      )

      break if resp.messages.empty?
      block.call resp.messages
    end
  end

  def send_message_batches(queue_url, batch)
    entries = batch.map do |msg|
      { id: msg.message_id, message_body: msg.body }
    end
    sqs.send_message_batch(queue_url: queue_url, entries: entries)
  end

  def delete_message_batches(queue_url, batch)
    entries = batch.map do |m|
      { id: m.message_id, receipt_handle: m.receipt_handle }
    end
    sqs.delete_message_batch(queue_url: queue_url, entries: entries)
  end

  private

  def self.sqs
    @sqs ||= Aws::SQS::Client.new
  end
end
