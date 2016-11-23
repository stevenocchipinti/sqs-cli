require "inquirer"

module Cli
  extend self

  def self.wait_with_message(message)
    print message
    result = yield if block_given?
    print "\r\e[K"
    result
  end

  def self.list_or_file(message, items, opts={})
    items += ["FILE..."] if opts[:include_file]

    index = Ask.list message, items
    if opts[:include_file] && index == items.size - 1
      { filename: (Ask.input "Filename", default: "sqs-cli.data") }
    else
      { selected_item: items[index] }
    end
  end
end
