module Propublica
  module Nonprofits
    class Organization
      class FilingsWithoutDataParser < DynamicParser
        fields :tax_prd, :tax_prd_yr, :formtype, :formtype_str, :pdf_url
      end
    end
  end
end
