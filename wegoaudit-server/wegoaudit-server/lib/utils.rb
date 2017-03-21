module Retrocalc
  def self.local_ip
    require 'socket'
    ip = Socket.ip_address_list.find(&:ipv4_private?)
    ip.ip_address if ip
  end
end
