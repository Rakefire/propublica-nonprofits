require "test_helper"

class Propublica::NonprofitsTest < Minitest::Test
  parallelize_me!

  def test_that_it_has_a_version_number
    refute_nil ::Propublica::Nonprofits::VERSION
  end

  def test_it_searchs_a_single_nonprofit
    VCR.use_cassette('rural_action_search') do
      rural_action_results = Propublica::Nonprofits.search("rural action inc")
      first_item = rural_action_results.first

      assert_instance_of Enumerator::Lazy, rural_action_results
      assert_instance_of Propublica::Nonprofits::Organization, first_item

      assert_equal "THE PLAINS", first_item.basic.city
      assert_equal 311124220, first_item.basic.ein
      assert_equal "RURAL ACTION INC", first_item.basic.name
      assert_equal "S320", first_item.basic.ntee_code
      assert_equal "S320", first_item.basic.raw_ntee_code
      assert_equal 538.7942, first_item.basic.score
      assert_equal "OH", first_item.basic.state
      assert_equal "31-1124220", first_item.basic.strein
      assert_equal "RURAL ACTION INC", first_item.basic.sub_name
      assert_equal 3, first_item.basic.subseccd
      assert first_item.basic.has_subseccd
      assert_nil first_item.basic.have_extracts
      assert_nil first_item.basic.have_filings
      assert_nil first_item.basic.have_pdfs
    end
  end

  def test_it_requests_details_if_not_fetched_yet
    VCR.use_cassette('rural_action_search_with_details') do
      rural_action_results = Propublica::Nonprofits.search("rural action inc")
      first_item = rural_action_results.first

      assert_equal "THE PLAINS", first_item.details.city
    end
  end

  def test_it_searchs_multiple_nonprofits
    VCR.use_cassette('rural_search') do
      rural_action_results = Propublica::Nonprofits.search("rural")

      assert_instance_of Enumerator::Lazy, rural_action_results
      assert_operator rural_action_results.size, :>, 1

      rural_action_results.each do |org|
        assert_instance_of Propublica::Nonprofits::Organization, org
      end
    end
  end

  def test_it_finds_organization_attribues_by_ein
    VCR.use_cassette('rural_action_ein') do
      rural_action = Propublica::Nonprofits.find_attributes(311124220)
      assert_instance_of Hash, rural_action
    end
  end

  def test_it_finds_organization_by_ein
    VCR.use_cassette('rural_action_ein') do
      rural_action = Propublica::Nonprofits.find(311124220)
      assert_instance_of Propublica::Nonprofits::Organization, rural_action
    end
  end

  def test_it_raises_error_if_fetching_basic_data_from_ein_find
    VCR.use_cassette('rural_action_ein') do
      rural_action = Propublica::Nonprofits.find(311124220)

      error = assert_raises Propublica::Nonprofits::DataNotFetched do
          rural_action.basic.city
        end

      assert_includes error.message, "BasicParser#city not fetched from API. This may be due to an API error or because you tried to access a Basic property on the full results"
    end
  end

  def test_organization_details_parsing
    VCR.use_cassette('rural_action_ein') do
      rural_action = Propublica::Nonprofits.find(311124220)

      assert_equal rural_action.details.id, 311124220
      assert_equal rural_action.details.ein, 311124220
      assert_equal rural_action.details.name, "RURAL ACTION INC"
      assert_equal rural_action.details.address, "11350 JACKSON DR"
      assert_equal rural_action.details.city, "THE PLAINS"
      assert_equal rural_action.details.state, "OH"
      assert_equal rural_action.details.zipcode, "45780-1229"
      assert_equal rural_action.details.exemption_number, 0
      assert_equal rural_action.details.subsection_code, 3
      assert_equal rural_action.details.affiliation_code, 3
      assert_equal rural_action.details.classification_codes, "1000"
      assert_equal rural_action.details.ruling_date, "1985-06-01"
      assert_equal rural_action.details.deductibility_code, 1
      assert_equal rural_action.details.activity_codes, "149000000"
      assert_equal rural_action.details.foundation_code, 16
      assert_equal rural_action.details.organization_code, 1
      assert_equal rural_action.details.exempt_organization_status_code, 1
      assert_equal rural_action.details.tax_period, "2016-12-01"
      assert_equal rural_action.details.asset_code, 6
      assert_equal rural_action.details.income_code, 6
      assert_equal rural_action.details.filing_requirement_code, 1
      assert_equal rural_action.details.pf_filing_requirement_code, 0
      assert_equal rural_action.details.accounting_period, 12
      assert_equal rural_action.details.asset_amount, 1287004
      assert_equal rural_action.details.income_amount, 2391939
      assert_equal rural_action.details.revenue_amount, 2391939
      assert_equal rural_action.details.ntee_code, "S320"
      assert_equal rural_action.details.created_at, "2018-04-20T23:42:48.118Z"
      assert_equal rural_action.details.updated_at, "2018-04-20T23:42:48.118Z"
      assert_nil rural_action.details.careofname
      assert_nil rural_action.details.data_source
      assert_nil rural_action.details.have_extracts
      assert_nil rural_action.details.have_pdfs
      assert_nil rural_action.details.sort_name
    end
  end

  def test_organization_filings_with_data_parsing
    VCR.use_cassette('rural_action_ein') do
      rural_action = Propublica::Nonprofits.find(311124220)

      rural_action.filings_with_data.each do |filing_data|
        assert_instance_of Propublica::Nonprofits::Organization::FilingsWithDataParser, filing_data

        assert_instance_of Integer, filing_data.tax_prd
        assert_instance_of Integer, filing_data.tax_prd_yr
        assert_instance_of Integer, filing_data.formtype
        assert_instance_of String, filing_data.pdf_url
        assert_instance_of String, filing_data.updated
        assert_instance_of Integer, filing_data.totrevenue
        assert_instance_of Integer, filing_data.totfuncexpns
        assert_instance_of Integer, filing_data.totassetsend
        assert_instance_of Integer, filing_data.totliabend
        assert_instance_of Float, filing_data.pct_compnsatncurrofcr
        assert_instance_of NilClass, filing_data.tax_pd
        assert_instance_of Integer, filing_data.subseccd
        assert_instance_of String, filing_data.unrelbusinccd
        assert_instance_of Integer, filing_data.initiationfees
        assert_instance_of Integer, filing_data.grsrcptspublicuse
        assert_instance_of Integer, filing_data.grsincmembers
        assert_instance_of Integer, filing_data.grsincother
        assert_instance_of Integer, filing_data.totcntrbgfts
        assert_instance_of Integer, filing_data.totprgmrevnue
        assert_instance_of Integer, filing_data.invstmntinc
        assert_instance_of Integer, filing_data.txexmptbndsproceeds
        assert_instance_of Integer, filing_data.royaltsinc
        assert_instance_of Integer, filing_data.grsrntsreal
        assert_instance_of Integer, filing_data.grsrntsprsnl
        assert_instance_of Integer, filing_data.rntlexpnsreal
        assert_instance_of Integer, filing_data.rntlexpnsprsnl
        assert_instance_of Integer, filing_data.rntlincreal
        assert_instance_of Integer, filing_data.rntlincprsnl
        assert_instance_of Integer, filing_data.netrntlinc
        assert_instance_of Integer, filing_data.grsalesecur
        assert_instance_of Integer, filing_data.grsalesothr
        assert_instance_of Integer, filing_data.cstbasisecur
        assert_instance_of Integer, filing_data.cstbasisothr
        assert_instance_of Integer, filing_data.gnlsecur
        assert_instance_of Integer, filing_data.gnlsothr
        assert_instance_of Integer, filing_data.netgnls
        assert_instance_of Integer, filing_data.grsincfndrsng
        assert_instance_of Integer, filing_data.lessdirfndrsng
        assert_instance_of Integer, filing_data.netincfndrsng
        assert_instance_of Integer, filing_data.grsincgaming
        assert_instance_of Integer, filing_data.lessdirgaming
        assert_instance_of Integer, filing_data.netincgaming
        assert_instance_of Integer, filing_data.grsalesinvent
        assert_instance_of Integer, filing_data.lesscstofgoods
        assert_instance_of Integer, filing_data.netincsales
        assert_instance_of Integer, filing_data.miscrevtot11e
        assert_instance_of Integer, filing_data.compnsatncurrofcr
        assert_instance_of Integer, filing_data.othrsalwages
        assert_instance_of Integer, filing_data.payrolltx
        assert_instance_of Integer, filing_data.profndraising
        assert_instance_of Integer, filing_data.txexmptbndsend
        assert_instance_of Integer, filing_data.secrdmrtgsend
        assert_instance_of Integer, filing_data.unsecurednotesend
        assert_instance_of Integer, filing_data.retainedearnend
        assert_instance_of Integer, filing_data.totnetassetend
        assert_instance_of String, filing_data.nonpfrea
        assert_instance_of Integer, filing_data.gftgrntsrcvd170
        assert_instance_of Integer, filing_data.txrevnuelevied170
        assert_instance_of Integer, filing_data.srvcsval170
        assert_instance_of Integer, filing_data.grsinc170
        assert_instance_of Integer, filing_data.grsrcptsrelated170
        assert_instance_of Integer, filing_data.totgftgrntrcvd509
        assert_instance_of Integer, filing_data.grsrcptsadmissn509
        assert_instance_of Integer, filing_data.txrevnuelevied509
        assert_instance_of Integer, filing_data.srvcsval509
        assert_instance_of Integer, filing_data.subtotsuppinc509
        assert_instance_of Integer, filing_data.totsupp509
        assert_instance_of Integer, filing_data.ein
      end
    end
  end

  def test_organization_filings_without_data_parsing
    VCR.use_cassette('rural_action_ein') do
      rural_action = Propublica::Nonprofits.find(311124220)

      rural_action.filings_without_data.each do |filing_data|
        assert_instance_of Propublica::Nonprofits::Organization::FilingsWithoutDataParser, filing_data

        assert_instance_of Integer, filing_data.tax_prd
        assert_instance_of Integer, filing_data.tax_prd_yr
        assert_instance_of Integer, filing_data.formtype
        assert_instance_of String, filing_data.formtype_str
        assert_instance_of String, filing_data.pdf_url
      end
    end
  end

  def test_organization_data_source_parsing
    VCR.use_cassette('rural_action_ein') do
      rural_action = Propublica::Nonprofits.find(311124220)

      assert_includes rural_action.data_source, "ProPublica Nonprofit Explorer API"
    end
  end

  def test_organization_api_version_parsing
    VCR.use_cassette('rural_action_ein') do
      rural_action = Propublica::Nonprofits.find(311124220)

      assert_equal 2, rural_action.api_version
    end
  end

  def test_basic_attribute_parsing
    basic_attrs = { "ein" => 1 }

    organization = Propublica::Nonprofits::Organization.new("basic" => basic_attrs)
    assert_equal organization.basic.ein, 1
  end

  def test_it_raises_warning
    turn_off_web_stub! do
      result = Propublica::Nonprofits.find(311124220)
      assert_equal result.error,
        %(WARNING: Version 2 of the ProPublica Nonprofit Explorer API will be deprecated by the end of 2017. Check https://projects.propublica.org/nonprofits/api/ for updates at a later date.)
    end
  end

  def turn_off_web_stub!
    VCR.turn_off!
    WebMock.allow_net_connect!
    yield
    WebMock.disable_net_connect!
    VCR.turn_on!
  end
end
