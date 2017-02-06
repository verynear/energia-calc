class LogoutService < BaseServicer
  def execute!
    storage = NSHTTPCookieStorage.sharedHTTPCookieStorage
    storage.cookies.each do |cookie|
      storage.deleteCookie(cookie)
    end
    NSUserDefaults.standardUserDefaults['auth_token'] = nil
    NSUserDefaults.standardUserDefaults.synchronize
  end
end
