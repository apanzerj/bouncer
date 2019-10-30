%w(github_users.rb namely_db.rb ldap_wrapper.rb user.rb).each{ |file| require_relative "./models/#{file}" }
require 'csv'
require 'octokit'

SERVICE_ACCOUNT = %()
  
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

generated_file = "bouncer_#{Time.now.utc.to_i}.csv"
CSV.open(generated_file, 'w') do |csv|
  csv << %w(Status GithubID GithubAdmin Team Email)
  @invalid_upn.each do |invalid_upn|
    csv << invalid_upn
  end
  @valid.each do |valid|
    csv << valid
  end
end

require 'sendgrid-ruby'
include SendGrid

m = Mail.new
m.from = Email.new(email: 'release_user@optimizely.com')
m.subject = "Github Audit: #{Time.now.utc}"
m_p = Personalization.new
m_p.add_to(Email.new(email: 'itsdtickets@optimizely.com', name: 'IT Service Desk'))
m.add_personalization(m_p)
m.add_content(Content.new(type: 'text/plain', value: "Please see the attached report."))
attachment = Attachment.new
attachment.content = Base64.urlsafe_encode64(File.read(generated_file))
attachment.type = 'text/plain'
attachment.filename = generated_file
attachment.disposition = 'attachment'
attachment.content_id = 'report'
m.add_attachment(attachment)

sg = SendGrid::API.new(api_key: ENV['SENDGRID_KEY'], host: 'https://api.sendgrid.com')
response = sg.client.mail._('send').post(request_body: m.to_json)
