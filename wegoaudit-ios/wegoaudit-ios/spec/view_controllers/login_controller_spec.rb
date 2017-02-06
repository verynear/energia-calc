describe 'LoginController' do
  tests LoginController

  before do
    controller.app_delegate.stub!(:update_application)
  end

  context 'connected' do
    it 'stores a UIWebView' do
      controller.webView.should.not == nil

      controller.webView.class.name.should == 'UIWebView'
    end

    it 'calls store_user_information and pushes auditsTabBarController on successful authentication' do
      request = mock('request')

      controller.should_receive(:store_user_information)
      controller.should_receive(:get_and_push_view_controller).with('auditsTabBarController')
      controller.successful_login(request)

      mock_expectation
    end

    it 'calls logout when the viewDidAppear' do
      controller.should_receive(:logout)
      controller.viewDidAppear(true)

      mock_expectation
    end
  end

  describe '.api_login_request' do
    it 'uses the correct login end point' do
      controller.stub!(:config)
                .and_return({api_login_base: 'http://10.0.1.13:9292/'})
      controller.api_login_request.URL.absoluteString
        .should == 'http://10.0.1.13:9292/signin'
    end
  end

  describe '.logout' do
    it 'clears out all of the cookies' do
      delete_cookies
      cookie_hash = { 'Domain' => '127.0.0.1',
                      'Path' => '/',
                      'Expires' => '2034-08-21 15:23:48 -0400',
                      'Value' => 'BAhbB0kiD2pjdXRsZXJhcGkGOgZFVEkiDXJ1OE92OEx6BjsAVA%3D%3D--460322593fd2b9b78a5f42b815d3791127a673fa',
                      'Created' => 430341828.0,
                      'Name' => 'token'
                    }
      NSHTTPCookieStorage.sharedHTTPCookieStorage.setCookie(NSHTTPCookie.cookieWithProperties(cookie_hash))
      NSHTTPCookieStorage.sharedHTTPCookieStorage.cookies.size.should == 1
      controller.logout
      NSHTTPCookieStorage.sharedHTTPCookieStorage.cookies.size.should == 0
    end
  end
end
