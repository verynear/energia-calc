require 'door_stop'
require 'rack/lint'
require 'rack/mock'

describe DoorStop do
  let(:user) { 'a' * 32 }

  def create_password(secret, user=user)
   Digest::SHA1.hexdigest(user + secret)
  end

  describe '.authify' do
    it 'generates a random username and password' do
      user = 'random'
      DoorStop.should_receive(:random_string).and_return(user)
      password = create_password 'blarg', user
      DoorStop.authify('blarg').should == { username: user, password: password}
    end
  end

  describe '.random_string' do
    it 'generates correct length' do
      DoorStop.random_string(32).size.should == 32
    end

    it 'generates random strings' do
      string = DoorStop.random_string(32)
      string.should_not == DoorStop.random_string(32)
    end
  end

  describe '.authenticate' do
    it 'returns false if user less than 32' do
      DoorStop.authenticate('four', 'pass', 'secret').should == false
    end

    it 'returns false if wrong password' do
      DoorStop.authenticate(user, 'pass', 'secret').should == false
    end

    it 'returns true if correct password' do
      pass = create_password 'secret'
      DoorStop.authenticate(user, pass, 'secret').should == true
    end
  end

  # test helpers from rack-auth-basic tests
  describe DoorStop::Authenticator do
    def unprotected_app
      Rack::Lint.new lambda { |env|
        [ 200, {'Content-Type' => 'text/plain'}, ["Hola"] ]
      }
    end

    def protected_app
      DoorStop::Authenticator.new unprotected_app, 'secret'
    end

    def request_with_basic_auth(username, password, &block)
      request 'HTTP_AUTHORIZATION' => 'Basic ' +
        ["#{username}:#{password}"].pack("m*"), &block
    end

    def request(headers = {})
      yield @request.get('/', headers)
    end

    before do
      @request = Rack::MockRequest.new(protected_app)
    end

    it 'returns application output if correct password' do
      pass = create_password 'secret'
      request_with_basic_auth user, pass do |response|
        response.status.should == 200
        response.body.to_s.should == 'Hola'
      end
    end

    it 'returns 401 if incorrect password' do
      request_with_basic_auth user, 'fail' do |response|
        response.status.should == 401
        response.body.to_s.should == ''
      end
    end
  end
end
