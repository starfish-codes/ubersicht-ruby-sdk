# Ubersicht API library for Ruby

This is the officially supported Ruby library for using Ubersicht's APIs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ubersicht-ruby-sdk', '0.2.0', require: 'ubersicht'
```

The latest `main` branch:

```ruby
gem 'ubersicht-ruby-sdk', git: 'https://github.com/starfish-codes/ubersicht-ruby-sdk.git',
                          branch: 'main', require: 'ubersicht'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ubersicht-ruby-sdk

## Usage

### Ingestion

Build client:

```sh
  client = Ubersicht::Ingestion::Client.new(
    token: '<ubersicht-plugin-token>',
    url: '<api-base-url>',
    debug: true
  )
```

Parameters:

* `token` - (required) authentication token for Ubersicth plugin.
* `url` - (required) Ubersicht API root url. Different for production and testing environment.
* `debug` - (optional) default=false. If true then request is performed in the current thread, if false then new thread is created.

Send event:

```sh
  # required
  transaction_type = 'DeviceBinding'
  event_code = 'REQUESTED'

  payload = {
    event_date: 2021-10-10 10:10:10,
    event_group_id: 'eb2bc8bb-f584-4801-b98c-361a0c2d38f8',
    event_id: 'ed62d0c1-f2a5-41b7-ab58-24c033eec508',
  }
  client.ingest(transaction_type, event_code, payload)
```

Event attributes:

* `transaction_type` (required) - a process or resource to which event belongs, e.g. DeviceBinding, Authentication
* `event_code` (required) - string identifier of a transition
* `event_date` - time when event was triggered
* `event_group_id` - correlated transaction id (allows to link some events together)
* `event_id` - unique event identifier (allows to silence duplicated events)

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`,
which will create a git tag for the version, push git commits and tags, and push the `.gem`
file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ubersicht-ruby-sdk.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
