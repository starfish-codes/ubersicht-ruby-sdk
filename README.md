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
* `url` - Ubersicht API root url. Different for production and testing environment.

Send event:

```sh
  client.ingest(transaction_type, event_code, time, payload = {})
```

Attributes:

* `transaction_type` (required) - a process or resource to which event belongs, e.g. DeviceBinding, Authentication
* `event_code` (required) - string identifier of a transition
* `time` (required) - when event was triggered

* `payload` (optional) - additional attributes of event, like device_id, user_id, ...
* `payload.event_id` - unique event identifier (allows to silence duplicated events)
* `payload.event_group_id` - correlated transaction id (allows to link some events together)

Example:

```sh
  payload = {
    event_id: 'ed62d0c1-f2a5-41b7-ab58-24c033eec508',
    event_group_id: 'eb2bc8bb-f584-4801-b98c-361a0c2d38f8',
    ... other attributes ...
  }
  client.ingest('DeviceBinding', 'REQUESTED', '2021-10-10 10:10:10', payload)
```

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
