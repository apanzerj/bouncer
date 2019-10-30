# GithubUsers - acts as a wrapper class for octokit
require 'octokit'

class GithubUsers
  def self.all
    @all ||= client.organization_members(ENV['ORG_NAME'])
  end

  def self.admins
    @admins ||= client.organization_members(ENV['ORG_NAME'], role: :admin)
  end

  def self.client
    @client ||= Octokit::Client.new(access_token: ENV.fetch('GH_ACCESS_TOKEN'))
  end
end
