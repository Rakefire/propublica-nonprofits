module Propublica
  module Nonprofits
    class Organization
      class DynamicParser
        def self.fields(*fields)
          fields.each do |field|
            define_method field do
              self.instance_variable_get("@attributes")[field.to_s]
            end
          end
        end

        def initialize(attributes)
          @attributes = attributes
        end

        private

        attr_reader :attributes
      end
    end
  end
end
