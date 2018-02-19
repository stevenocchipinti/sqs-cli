# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sqs_cli/version'

Gem::Specification.new do |spec|
  spec.name          = "sqs-cli"
  spec.version       = SqsCli::VERSION
  spec.authors       = ["Steven Occhipinti"]
  spec.email         = ["dev@stevenocchipinti.com"]

  spec.summary       = "A simple CLI to move messages between SQS queues"
  spec.homepage      = "https://github.com/stevenocchipinti/sqs-cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "aws-sdk-sqs"
  spec.add_runtime_dependency "inquirer"
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
