require "propublica/nonprofits/version"
require "propublica/nonprofits/organization"

require "faraday"
require "json"

API_BASE_URL = %(https://projects.propublica.org)
API_SEARCH_PATH = %(/nonprofits/api/v2/search.json)

module Propublica
  module Nonprofits
    def self.search(term, state: nil, page: nil, fetch_all: false)
      organizations = []
      more_pages = true

      page =
        case
        when page
          page
        when fetch_all && page
          raise "Page is set but we are fetching all, chose one or the other"
        else
          0
        end

      while (more_pages)
        response = connection.get do |request|
          request.url(API_SEARCH_PATH)

          request.params["q"] = term
          request.params["state[id]"] = state if state
          request.params["page"] = page if page
        end
        

        attributes = JSON.parse(response.body)
        new_organizations = attributes.fetch("organizations", [])
        organizations.push(*new_organizations)

        more_pages = fetch_all && new_organizations.any?
        page += 1
      end

      organizations.lazy.map do |basic_attrs|
        Propublica::Nonprofits::Organization.new("basic" => basic_attrs)
      end
    end

    def self.find(ein)
      attributes = self.find_attributes(ein)
      Propublica::Nonprofits::Organization.new(attributes)
    end

    def self.find_attributes(ein)
      response = connection.get("/nonprofits/api/v2/organizations/#{ein}.json")
      JSON.parse(response.body)
    end

    def self.connection
      @connection ||= Faraday.new(url: API_BASE_URL)
    end

    class Error < StandardError; end
    class DataNotFetched < Error; end
  end
end
