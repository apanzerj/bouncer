# NamelyDB - act as a container for namely api data
# Deprecated as Namely is Lame...ly. Their API has too many issues.
require 'namely'
require 'csv'
class NamelyDB
  attr_reader :data

  def self.export
    CSV.open("namely_export_#{Time.now.utc.to_i}.csv", 'w') do |file_out|
      self.new.data.each do |m|
        next if m.user_status != 'active'
        file_out << [m.github_id_adept_only, m.email, m.team]
      end
    end
  end

  def initialize
    puts "Namely request started."
    @data =  namely_client.profiles.all
    puts "Namely request complete."
  end

  def find(github_id)
    data.detect{|u| github_id == u.github_id_adept_only }
  end

  def in_namely?(github_id)
    !find(github_id).nil?
  end

  def is_active?(github_id)
    m = find(github_id)
    return false if m.nil?
    m.user_status == 'active'
  end

  private

  def namely_client
    @namely_client ||= Namely::Connection.new(access_token: ENV.fetch('NAMELY_TOKEN'), subdomain: 'optimizely')
  end
end

module Namely
  require 'benchmark'
  class ResourceGateway
    def json_index_paged
      Enumerator.new do |y|
        params = {}

        loop do
          objects = ''
          result = Benchmark.realtime do
            objects = get("/#{endpoint}", params)[resource_name]
          end

          puts result

          break if objects.empty?

          objects.each { |o| y << o }

          params[:after] = objects.last["id"]
        end
        puts "Fetch done."
      end
    end
  end
end
