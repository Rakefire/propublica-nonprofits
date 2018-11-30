module Propublica
  module Nonprofits
    class Organization
      class DynamicParser
        def self.fields(*fields)
          @fields = fields
          fields.each do |field|
            define_method field do
              vars = self.instance_variable_get("@attributes")
              vars.fetch(field.to_s) { raise_field_fetch_error(field) }
            end
          end
        end

        def initialize(attributes)
          @attributes = attributes || {}
        end

        def fields
          self.class.instance_variable_get("@fields")
        end

        private

        attr_reader :attributes

        def raise_field_fetch_error(field)
          class_name = self.class.to_s.split("::").last
          raise Propublica::Nonprofits::DataNotFetched,
            "#{class_name}##{field} not fetched from API. This may be due to an API error or because you tried to access a Basic property on the full results"
        end
      end
    end
  end
end
