RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

%w(github_users.rb namely_db.rb ldap_wrapper.rb user.rb).each{ |file| require_relative "../models/#{file}" }
ENV['AD_USER'] = 'foo'
ENV['AD_PASS'] = 'bar'
