# Ubersicht API library for Ruby

This is the officially supported Ruby library for using Ubersicht's APIs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ubersicht-ruby-sdk'
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
    user: 'user'
  )
```

Parameters:

* `hmac_key` - used for signing notification on client side and validation on server side (Ubersicht plugin config)
* `account_id` - account which receives notification events
* `pass` - basic auth password (Ubersicht plugin config)
* `user` - basic auth username (Ubersicht plugin config)
* `provider` - plugin provider in Ubersicht platform, e.g. DAuth
* `url` - Ubersicht API root url, is different testing an production environment

Send events:

```sh
  events = [
    {
      event_code: 'REQUESTED',
      event_date: 2021-10-10 10:10:10,
      transaction_id, 'eb2bc8bb-f584-4801-b98c-361a0c2d38f8',
      type: 'DeviceBinding'
      payload, {
        device_id: '500',
        user_id: '1000'
      }
    }
  ]
  client.ingest_events(events)
```

Attributes:

* `event_code` (required) - string identifier of a transition
* `event_date` (required) - when event was triggered
* `type` (required) - a process or resource to which event belongs, e.g. DeviceBinding, Authentication

* `transaction_id` (optional) - correlated transaction id, which allows to link events together.
  If is blank then we create a new transaction.
* `payload` (optional) - additional attributes of event, like device_id, user_id, ...

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
