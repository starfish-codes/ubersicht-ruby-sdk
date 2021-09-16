# Ubersicht API library for Ruby

This is the officially supported Ruby library for using Ubersicht's APIs.

## Installation

Add this line to your application's Gemfile:

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
    hmac_key: '44782DEF547AAA06C910C43932B1EB0C71FC68D9D0C057550C48EC2ACF6BA056',
    account_id: '1001',
    pass: 'password',
    provider: 'DAuth',
    url: '<api-base-url>',
    user: 'user',
    debug: true
  )
```

Parameters:

* `hmac_key` - (required) used for signing notification on client side and validation on server side (Ubersicht plugin config)
* `account_id` - (required) account which receives notification events
* `pass` - (required) basic auth password (Ubersicht plugin config)
* `user` - (required) basic auth username (Ubersicht plugin config)
* `provider` - (required) plugin provider in Ubersicht platform, e.g. DAuth
* `url` - (required) Ubersicht API root url. Different for production and testing environment.
* `debug` - (optional) default=false. If true then request is performed in the current thread, if false then new thread is created.

Send event:

```sh
  event = {
    # required
    transaction_type: 'DeviceBinding'
    event_code: 'REQUESTED',
    # optional
    event_date: 2021-10-10 10:10:10,
    event_group_id: 'eb2bc8bb-f584-4801-b98c-361a0c2d38f8',
    event_id: 'ed62d0c1-f2a5-41b7-ab58-24c033eec508',,
  }
  client.ingest(**event)
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
