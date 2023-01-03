$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "bundler/setup"

require "minitest/autorun"
require "minitest/line/describe_track"
require "webmock/minitest"
require "pry"
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "test/fixtures"
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :webmock
end

require "propublica/nonprofits"