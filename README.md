[![Build Status](https://travis-ci.org/Rakefire/propublica-nonprofits.svg?branch=master)](https://travis-ci.org/Rakefire/propublica-nonprofits)

# Propublica::Nonprofits

Simple wrapper around the ProPublica Nonprofits API database API.

https://projects.propublica.org/nonprofits/api/

In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/propublica/nonprofits`. To experiment with that code, run `bin/console` for an interactive prompt. To test that code, run `bin/test` to run the test suite.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'propublica-nonprofits'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install propublica-nonprofits

## Usage

### Search
To search the API and return an array of Propublica::Nonprofits::Objects, use the following:

    results = Propublica::Nonprofits.search("rural action inc")
    result = results.first

    result.basic.ein # the basic parser is used by default for a search

    # If desiring more details, you can call .details, .filings_with_data,
    # .data_source, .api_version, or .error and another API call is triggered
    # to fetch all data
    result.details.deductibility_code
    result.filings_with_data.first.totassetsend

*Note: This will currently only return the first 100 organizations*
*Note: This is returned as a Enumerator::Lazy, to be as memory efficient as possible, if you do something like `Propublica::Nonprofits.search("rural").first(10)`*


### EIN Lookup - As Organization
To look up an organization by its ein and return all details, use the following:

    ein = 311124220
    org = Propublica::Nonprofits.find(ein)

    org.details.name
    org.details.activity_codes
    org.details.income_amount
    org.details.revenue_amount

    org.filings_with_data
    org.filings_without_data

    org.data_source
    org.api_version
    org.error

    # To explore what fields are returned
    org.details.fields
    org.filings_with_data.first.fields
    org.filings_without_data.first.fields

  *Note: This will return an organization, with details, filings_with_data, and filings_without_data*

### EIN Lookup - As Hash

If you need a more simplified data structure to pluck out just one or two fields,
consider using the `find_attributes` method.

    ein = 311124220
    attributes = Propublica::Nonprofits.find_attributes(ein)

    attributes.dig("organization", "name")
    attributes.dig("filings_without_data").first.dig("pdf_url")

## TODO

- Add more robust searching parameters https://projects.propublica.org/nonprofits/api/#endpoint-search-example
- Handle paginated search results (with Enumerator::Lazy)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/propublica-nonprofits. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Propublica::Nonprofits project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Rakefire/propublica-nonprofits/blob/master/CODE_OF_CONDUCT.md).
