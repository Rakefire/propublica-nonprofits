module Propublica
  module Nonprofits
    class Organization
      class FilingsWithDataParser < DynamicParser
        fields :tax_prd, :tax_prd_yr, :formtype, :pdf_url, :updated,
               :totrevenue, :totfuncexpns, :totassetsend, :totliabend,
               :pct_compnsatncurrofcr, :tax_pd, :subseccd, :unrelbusinccd,
               :initiationfees, :grsrcptspublicuse, :grsincmembers,
               :grsincother, :totcntrbgfts, :totprgmrevnue, :invstmntinc,
               :txexmptbndsproceeds, :royaltsinc, :grsrntsreal,
               :grsrntsprsnl, :rntlexpnsreal, :rntlexpnsprsnl, :rntlincreal,
               :rntlincprsnl, :netrntlinc, :grsalesecur, :grsalesothr,
               :cstbasisecur, :cstbasisothr, :gnlsecur, :gnlsothr, :netgnls,
               :grsincfndrsng, :lessdirfndrsng, :netincfndrsng,
               :grsincgaming, :lessdirgaming, :netincgaming,
               :grsalesinvent, :lesscstofgoods, :netincsales,
               :miscrevtot11e, :compnsatncurrofcr, :othrsalwages, :payrolltx,
               :profndraising, :txexmptbndsend, :secrdmrtgsend, :unsecurednotesend,
               :retainedearnend, :totnetassetend, :nonpfrea, :gftgrntsrcvd170,
               :txrevnuelevied170, :srvcsval170, :grsinc170,
               :grsrcptsrelated170, :totgftgrntrcvd509, :grsrcptsadmissn509,
               :txrevnuelevied509, :srvcsval509, :subtotsuppinc509,
               :totsupp509, :ein
      end
    end
  end
end
