module Propublica
  module Nonprofits
    class Organization
      class BasicParser < DynamicParser
        fields :ein, :strein, :name, :sub_name, :city, :state, :ntee_code,
        :raw_ntee_code, :subseccd, :has_subseccd, :have_filings, :have_extracts,
        :have_pdfs, :score
      end
    end
  end
end
