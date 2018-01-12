# User - a generic user class to store info about a user.
require_relative 'github_users.rb'

class User
  attr_accessor :github_id

  def initialize(github_id:)
    @github_id = github_id
  end

  def in_ad?
    @in_ad ||= ldap.active?(ldap_record)
  end

  def email
    @email ||= ldap_record && ldap_record.userprincipalname&.first
  end

  def github_admin?
    !GithubUsers.admins.detect{|m| m.login == github_id }.nil?
  end

  def ldap
    @ldap ||= LdapWrapper.new
  end

  def ldap_record
    @ldap_record ||= ldap.find(github_id)
  end
end
