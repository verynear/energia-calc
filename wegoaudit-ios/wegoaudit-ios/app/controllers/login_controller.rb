class LoginController < UIViewController
  include BaseController

  attr_accessor :webView

  def viewDidLoad
    super

    self.title = 'Login'
    self.view.addSubview(get_web_view)
  end

  def viewDidAppear(animated)
    super

    if defaults['auth_token'].nil?
      logout
      @webView.loadRequest(api_login_request)
    else
      set_current_user
      app_delegate.load_cookies
      app_delegate.update_application
      self.push_audit_controller
    end
  end

  def set_current_user
    app_delegate.current_user = User.where(auth_token: defaults['auth_token']).first
  end

  def webViewDidFinishLoad(webview)
    request = webview.request

    if login_was_successful?(request)
      successful_login(request)
    elsif login_screen_shown?(request)
      populate_login_box
    end
  end

  def successful_login(request)
    store_user_information(request)
    app_delegate.save_cookies
    set_current_user
    app_delegate.update_application
    push_audit_controller
    @webView.goBack
  end

  def push_audit_controller
    get_and_push_view_controller('auditsTabBarController')
  end

  def store_user_information(request)
    response = NSURLCache.sharedURLCache.cachedResponseForRequest(request)
    error = Pointer.new(:object)
    data = NSJSONSerialization.JSONObjectWithData(response.data, options: NSJSONReadingMutableLeaves, error: error)

    service = HandlerService.new(object_class: User, params: data)
    service.execute

    service.object.last_logged_in = Time.now
    cdq.save

    app_delegate.current_user = service.object
    defaults['auth_token'] = data["auth_token"]
    defaults.synchronize
  end

  def logout
    LogoutService.execute!
  end

  def api_login_request
    to_request(to_url(api_login_endpoint))
  end

  def to_url(string)
    NSURL.URLWithString(string)
  end

  def to_request(url)
    NSURLRequest.requestWithURL(url)
  end

  def login_was_successful?(request)
    request_contains_url(request, api_user_endpoint)
  end

  def login_screen_shown?(request)
    request_contains_url(request, api_remote_login_endpoint)
  end

  def request_contains_url(request, url)
    request.URL.absoluteString[url] != nil
  end

  def populate_login_box
    user = User.last_logged_in_user
    if user
      str = "$('#username').val('#{user.username}');$('#password').focus();"
      @webView.stringByEvaluatingJavaScriptFromString(str);
    end
  end

  private

  def get_web_view
    @webView = UIWebView.alloc.initWithFrame(self.view.frame)
    @webView.delegate = self

    @webView.detectsPhoneNumbers = false
    @webView
  end

  def cleanup_webview
    @webView.delegate = nil
    @webView = nil
  end

  def api_login_base
    config[:api_login_base]
  end

  def api_login_endpoint
    "#{api_login_base}signin"
  end

  def api_user_endpoint
    "#{api_login_base}user"
  end

  def api_remote_login_endpoint
    "#{config[:wegowise_server_base]}login"
  end
end
