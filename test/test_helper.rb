$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "propublica/nonprofits"

require "minitest/autorun"
require "webmock/minitest"
require "pry"
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "test/fixtures"
  c.hook_into :webmock
end
