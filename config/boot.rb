# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

ENV['WEGOAUDIT_LOCAL_IP'] ||= begin
  require 'socket'
  ip = Socket.ip_address_list.detect { |intf| intf.ipv4_private? }
  ip.ip_address if ip
end

'''
module DefaultServerPort
  def default_options
    super.merge!(:Port => 9292,
                 :Host => ENV[''WEGOAUDIT_LOCAL_IP''])
  end
end
'''

require 'rails/commands/server'

module Rails
  class Server
    prepend DefaultServerPort
  end
end
