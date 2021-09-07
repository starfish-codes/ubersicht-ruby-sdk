require 'webmock/rspec'

allow = [
  '127.0.0.1'
]

WebMock.disable_net_connect!(allow: allow.compact, allow_localhost: true)
