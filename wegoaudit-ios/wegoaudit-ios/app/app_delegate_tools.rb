module AppDelegateTools
  def app_delegate
    UIApplication.sharedApplication.delegate
  end

  def can_edit_current_audit?
    current_audit && current_audit.locked_by == current_user.id
  end

  def current_audit
    app_delegate.current_audit
  end

  def current_user
    app_delegate.current_user
  end

  def defaults
    app_delegate.defaults
  end

  def client
    app_delegate.client
  end

  def config
    app_delegate.config
  end
end
