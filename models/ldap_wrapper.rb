# LdapWrapper - act as a wrapper for ldap gem
require 'net-ldap'

class LdapWrapper
  attr_reader :ldap

  ACCOUNT_DISABLED = 2
  ACCOUNT_ACTIVE = 0

  # LDAP Filters
  BASE = 'DC=ad,DC=optimizely,DC=net'
  PERSON = Net::LDAP::Filter.from_rfc2254('(objectClass=Person)')

  def initialize
    @ldap = Net::LDAP.new(:host => "USSC1SV-01DC.ad.optimizely.net", :port => "636", :encryption => :simple_tls, :base => BASE, :auth => { :method => :simple, :username => ENV.fetch('AD_USER'), :password => ENV.fetch('AD_PASS') })
  end

  def find(githubid)
    filter = Net::LDAP::Filter.from_rfc2254("(wWWHomePage=#{profile(githubid)})")
    ldap.search(base: "OU=Optimizely,#{BASE}", filter: PERSON&filter)&.first
  end

  def active?(ldap_record)
    return false if ldap_record.nil?
    return ldap_record.useraccountcontrol.first.to_i & 2 == ACCOUNT_ACTIVE
  end

  def profile(githubid)
    "https://github.com/#{githubid}"
  end
end
