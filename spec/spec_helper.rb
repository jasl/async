
if ENV['COVERAGE'] || ENV['TRAVIS']
	begin
		require 'simplecov'
		
		SimpleCov.start do
			add_filter "/spec/"
		end
		
		if ENV['TRAVIS']
			require 'coveralls'
			Coveralls.wear!
		end
	rescue LoadError
		warn "Could not load simplecov: #{$!}"
	end
end

require "bundler/setup"
require "async"
require "async/wrap/tcp"
require "async/wrap/udp"

RSpec.shared_context "reactor" do
	let(:reactor) {Async::Reactor.new}
	
	around(:each) do |example|
		reactor.run do
			example.run
		end
	end
end

RSpec.configure do |config|
	# Enable flags like --only-failures and --next-failure
	config.example_status_persistence_file_path = ".rspec_status"

	config.expect_with :rspec do |c|
		c.syntax = :expect
	end
end
