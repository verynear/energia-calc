# This class is a wrapper around Motion::Blitz that can be included in view
# controllers.
#
# Example:
#     start_activity("Doing something...")
#
#     stop_activity(success: "Something finished!")
#     stop_activity(error: "Something failed. :(")
#
#     stop_activity    # Dismiss with no message
module ActivityNotifier
  attr_accessor :hud_visible

  # Show the activity HUD and toggle `hud_visible` so that we know whether it's
  # appropriate to dismiss it later.
  def start_activity(*args)
    self.hud_visible = true
    Motion::Blitz.show(*args)
  end

  # Dismiss any currently active HUD. Do not show success or error state unless
  # there is actually a HUD visible.
  def stop_activity(options = {})
    return unless hud_visible || options.empty?

    if options[:success]
      Motion::Blitz.success(options[:success])
    elsif options[:error]
      Motion::Blitz.error(options[:error])
    else
      Motion::Blitz.dismiss
    end

    self.hud_visible = false
  end
end
