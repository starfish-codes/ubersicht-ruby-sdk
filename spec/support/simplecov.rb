if ENV['CI'] == 'true'
  require 'simplecov'

  SimpleCov.start do
    add_filter 'lib/ubersicht/version'

    merge_timeout 3600

    enable_coverage :branch
    primary_coverage :branch
    minimum_coverage line: 99, branch: 90
  end
end
