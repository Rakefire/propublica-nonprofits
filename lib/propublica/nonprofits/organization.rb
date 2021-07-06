module Propublica
  module Nonprofits
    class Organization
      def initialize(attributes)
        @attributes = attributes
      end

      def basic
        @basic ||= BasicParser.new(attributes["basic"])
      end

      def details
        ensure_full_request!
        @details ||= DetailsParser.new(attributes["organization"])
      end

      def filings_with_data
        ensure_full_request!
        @filings_with_data ||= attributes["filings_with_data"].map { |f| FilingsWithDataParser.new(f) }
      end

      def filings_without_data
        ensure_full_request!
        @filings_without_data ||= attributes["filings_without_data"].map { |f| FilingsWithoutDataParser.new(f) }
      end

      def data_source
        ensure_full_request!
        @data_source ||= attributes["data_source"]
      end

      def api_version
        ensure_full_request!
        @api_version ||= attributes["api_version"]
      end

      def error
        ensure_full_request!
        @error ||= attributes["error"] || ""
      end

      def error?
        !error.empty?
      end

      private

      attr_reader :attributes
      attr_accessor :full_request_made

      def full_request_made?
        !!full_request_made
      end

      def ensure_full_request!
        return if full_request_made?

        self.full_request_made = (attributes.keys & required_keys) == required_keys
        return if full_request_made?

        fetch_full_request!
      end

      def required_keys
        ["organization", "filings_with_data", "filings_without_data", "data_source", "api_version", "error"].freeze
      end

      def ein
        @attributes.dig("organization", "ein") || self.basic.ein
      end

      def fetch_full_request!
        # Fetch all attributes and merge with what we have now
        new_attrs = Propublica::Nonprofits.find_attributes(ein)
        attributes.merge!(new_attrs)
        self.full_request_made = true
      end
    end
  end
end

require "propublica/nonprofits/organization/dynamic_parser"
require "propublica/nonprofits/organization/basic_parser"
require "propublica/nonprofits/organization/details_parser"
require "propublica/nonprofits/organization/filings_with_data_parser"
require "propublica/nonprofits/organization/filings_without_data_parser"
