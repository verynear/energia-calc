module DisableContentReadableMargins
  def viewDidLoad
    # Disable readable content margins when available (iOS >= 9.0)
    if self.tableView.respond_to?(:cellLayoutMarginsFollowReadableWidth)
      self.tableView.cellLayoutMarginsFollowReadableWidth = false
    end

    super
  end
end
