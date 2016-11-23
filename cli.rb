require "inquirer"

module Cli
  extend self

  def self.wait_with_message(message)
    print message
    result = yield if block_given?
    print "\r\e[K"
    result
  end

  def self.prompt(message, opts={})
    using_file = opts.fetch(:include_file, false)

    return Ask.confirm message unless opts.fetch(:options, false)

    options = opts.fetch(:options, [])
    options += ["FILE..."] if using_file

    index = Ask.list message, options
    if using_file && index == options.size - 1
      {
        filename: (Ask.input "Filename", default: "sqs-cli.data")
      }
    else
      { selected_option: options[index] }
    end
  end
end
