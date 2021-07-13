require "propublica/nonprofits/version"
require "propublica/nonprofits/organization"

require "faraday"
require "json"

API_BASE_URL = %(https://projects.propublica.org)
API_SEARCH_PATH = %(nonprofits/api/v2/search.json)

def self.results(column_names)
  columns = column_names.each

  Enumerator.new do |yielder|
    loop do
      yielder << Event.where(columns.next => query)
    end

    yielder << Event.fuzzy_search(query)
  end
end

module Propublica
  module Nonprofits
    class DataNotFetched < StandardError
    end

    def self.search(term, state: nil, ntee: nil, page: nil, fetch_all: false)
      search_results(term, state: state, ntee: ntee, page: page, fetch_all: fetch_all)
        .flat_map(&:itself)
    end

    def self.lazy_search(term, state: nil, ntee: nil, page: nil, fetch_all: false)
      search_results(term, state: state, ntee: ntee, page: page, fetch_all: fetch_all)
        .lazy
        .flat_map(&:itself)
    end

    def self.search_results(term, state: nil, ntee: nil, page: nil, fetch_all: false)
      raise ArgumentError.new("`page` and `fetch_all` are both: choose one or the other") if fetch_all && page
      page ||= 0
      max_pages = nil

      Enumerator.new do |yielder|
        loop do
          params = {}
          params["q"] = term
          params["state[id]"] = state if state
          params["ntee[id]"] = ntee if ntee
          params["page"] = page if page

          response = Faraday.default_connection.get("#{API_BASE_URL}/#{API_SEARCH_PATH}", params)
          parsed_response =
            if response.body.is_a?(Hash)
              response.body
            else
              begin
                JSON.parse(response.body)
              rescue JSON::ParserError => e
                raise JSON::ParserError.new("Propublica API Parsing Error: #{e.message}")
              end
            end

          max_pages = parsed_response.dig("num_pages") || max_pages

          yielder <<
            parsed_response
              .fetch("organizations", [])
              .map { |basic_attrs| Propublica::Nonprofits::Organization.new("basic" => basic_attrs) }

          if fetch_all && page + 1 < max_pages
            page += 1
          else
            raise(StopIteration)
          end
        end
      end
    end

    def self.find(ein)
      attributes = self.find_attributes(ein)
      Propublica::Nonprofits::Organization.new(attributes)
    end

    def self.find_attributes(ein)
      response = Faraday.get("#{API_BASE_URL}/nonprofits/api/v2/organizations/#{ein}.json")
      if response.body.is_a?(Hash)
        response.body
      else
        begin
          JSON.parse(response.body)
        rescue JSON::ParserError => e
          raise JSON::ParserError.new("Propublica API Parsing Error: #{e.message}")
        end
      end
    end
  end
end
