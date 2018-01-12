%w(github_users.rb namely_db.rb ldap_wrapper.rb user.rb).each{ |file| require_relative "./models/#{file}" }
require 'dotenv'
Dotenv.load!

require 'csv'
require 'octokit'

SERVICE_ACCOUNT = %w(ci-optimizely houndci-bot opti-pci-jenkins optibot optibot-cd optibot-ci optimizely-namely optimizely-phabricator).freeze


Octokit.auto_paginate = true
exit 1 if ENV.fetch('GH_ACCESS_TOKEN').nil?


### Procedural code.
@not_in_namely = []
@invalid_upn = []
@valid = []

GithubUsers.all.each do |user|
  user_obj = User.new(github_id: user.login)
  next if SERVICE_ACCOUNT.include?(user.login)
  if user_obj.in_ad?
    @valid << ["Okay", user_obj.github_id, user_obj.github_admin?, user_obj.email]
  else
    @invalid_upn << ["Github ID not found", user_obj.github_id, user_obj.github_admin?, user_obj.email ]
  end
end


CSV.open ("namely_export_#{Time.now.utc.to_i}.csv", 'w') do |csv|
  csv << %w(Status GithubID GithubAdmin Team Email)
  @valid.each do |valid|
    csv << valid
  end
  @invalid_upn.each do |invalid_upn|
    csv << invalid_upn
  end
end
