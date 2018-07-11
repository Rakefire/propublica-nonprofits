require "propublica/nonprofits/version"
require "propublica/nonprofits/organization"

require 'faraday'
require 'json'

API_BASE_URL = %(https://projects.propublica.org/nonprofits/api/v2)

module Propublica
  module Nonprofits
    def self.search(term)
      response = Faraday.get("#{API_BASE_URL}/search.json?q='#{term}'")
      attributes = JSON.parse(response.body)
      organizations = attributes.dig("organizations")
      organizations.lazy.map do |basic_attrs|
        Propublica::Nonprofits::Organization.new("basic" => basic_attrs)
      end
    end

    def self.find(ein)
      attributes = self.find_attributes(ein)
      Propublica::Nonprofits::Organization.new(attributes)
    end

    def self.find_attributes(ein)
      response = Faraday.get("#{API_BASE_URL}/organizations/#{ein}.json")
      JSON.parse(response.body)
    end
  end
end
