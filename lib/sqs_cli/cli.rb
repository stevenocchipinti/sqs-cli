require "inquirer"

module Cli
  extend self

  def self.wait_with_message(message)
    print message
    result = yield if block_given?
    print "\r\e[K"
    result
  end

  def self.list_options(message, items, opts={})
    items += ["File..."] if opts[:include_file]
    items += ["STDOUT"] if opts[:include_stdout]

    index = Ask.list message, items
    if opts[:include_file] && items[index] == "File..."
      { filename: (Ask.input "Filename", default: "sqs-cli.b64") }
    elsif opts[:include_stdout] && items[index] == "STDOUT"
      { stream: $stdout }
    else
      { selected_item: items[index] }
    end
  end
end
