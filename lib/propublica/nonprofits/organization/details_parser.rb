module Propublica
  module Nonprofits
    class Organization
      class DetailsParser < DynamicParser
        fields :id, :ein, :name, :careofname, :address, :city, :state,
               :zipcode, :exemption_number, :subsection_code, :affiliation_code,
               :classification_codes, :ruling_date, :deductibility_code,
               :foundation_code, :activity_codes, :organization_code,
               :exempt_organization_status_code, :tax_period, :asset_code,
               :income_code, :filing_requirement_code, :pf_filing_requirement_code,
               :accounting_period, :asset_amount, :income_amount, :revenue_amount,
               :ntee_code, :sort_name, :created_at, :updated_at, :data_source,
               :have_extracts, :have_pdfs
      end
    end
  end
end
