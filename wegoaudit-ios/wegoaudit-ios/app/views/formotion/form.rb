module Formotion
  class Form < Formotion::Base
    def tableView(tableView, heightForHeaderInSection: section)
      if sections[section].title.nil?
        0.0
      else
        44.0
      end
    end

    def tableView(tableView, willDisplayHeaderView: view, forSection: section)
      view.textLabel.font = UIFont.boldSystemFontOfSize(18)
    end
  end
end
