module Propublica
  module Nonprofits
    class Organization
      class DynamicParser
        def self.fields(*fields)
          fields.each do |field|
            define_method field do
              vars = self.instance_variable_get("@attributes")
              vars.fetch(field.to_s) do
                class_name = self.class.to_s.split("::").last
                raise Propublica::Nonprofits::DataNotFetched,
                  "#{class_name}##{field} not fetched from API. This may be due to an API error or because you tried to access a Basic property on the full results"
              end
            end
          end
        end

        def initialize(attributes)
          @attributes = attributes || {}
        end

        private

        attr_reader :attributes
      end
    end
  end
end
