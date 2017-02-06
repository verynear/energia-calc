require 'digest/sha1'
require 'rack'

class DoorStop
  def self.authify(secret)
    user = random_string 32
    { :username => user, :password => Digest::SHA1.hexdigest(user + secret) }
  end

  def self.random_string(length)
    chars = ('a'..'z').to_a
    (1..length).map {|e| chars[rand(chars.size - 1)] }.join('')
  end

  def self.authenticate(username, password, secret)
    username.length >= 32 && Digest::SHA1.hexdigest(username + secret) == password
  end

  # Use as rack middleware:
  #   use Doorstop::Authenticator, 'somesecret'
  class Authenticator < Rack::Auth::Basic
    def initialize(app, secret)                                                                                                                                                          super(app) do |username, password|
        DoorStop.authenticate(username, password, secret)
      end
    end
  end
end
