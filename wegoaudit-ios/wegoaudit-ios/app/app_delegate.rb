class AppDelegate
  include CDQ

  attr_accessor :connected,
                :current_audit,
                :current_user,
                :main_nav_controller

  attr_reader :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    cdq.setup

    config

    return true if RUBYMOTION_ENV == 'test'

    # Start the HockeyApp crash reporter and analytics
    BITHockeyManagerLauncher.new.start

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @main_nav_controller = UINavigationController.alloc.init

    @initial_controller = @login_controller = LoginController.alloc.init

    @main_nav_controller.pushViewController(@initial_controller,
                                             animated: false)
    @window.rootViewController = @main_nav_controller
    @window.makeKeyAndVisible

    true
  end

  def config
    @config ||= WegoAuditConfig.new
  end

  def storyboard
    @storyboard ||= UIStoryboard.storyboardWithName('Main', bundle: nil)
  end

  def get_view_controller(controller_name)
    storyboard.instantiateViewControllerWithIdentifier(controller_name)
  end

  def defaults
    @defaults ||= NSUserDefaults.standardUserDefaults
  end

  def client
    @client = AFMotion::SessionClient.build(config[:api_login_base]) do
      session_configuration :default

      header "Accept", "application/json"

      response_serializer :json
    end
  end

  def save_cookies
    cookies_data = NSKeyedArchiver.archivedDataWithRootObject(NSHTTPCookieStorage.sharedHTTPCookieStorage.cookies);
    defaults[:session_cookies] = cookies_data
    defaults.synchronize
  end

  def load_cookies
    cookies = NSKeyedUnarchiver.unarchiveObjectWithData(defaults[:session_cookies])
    cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage

    cookies.each do |cookie|
      cookieStorage.setCookie(cookie)
    end
  end

  def update_application
    ApplicationUpdateService.execute!
  end
end
