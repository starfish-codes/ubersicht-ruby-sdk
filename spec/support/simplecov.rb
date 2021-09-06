if ENV['CI'] == 'true'
  require 'simplecov'

  SimpleCov.start :rails do
    merge_timeout 3600

    enable_coverage :branch
    primary_coverage :branch
    minimum_coverage line: 99, branch: 99
  end
end
