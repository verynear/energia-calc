module Features
  module ModalSupport
    def dismiss_modal
      within('.modal') { page.find('a.js-modal-close').click }
    end

    def fill_in_date_field_in_modal(selector, options)
      fill_in_field_in_modal(selector, options.merge(field_type: :date))
    end

    def fill_in_field_in_modal(selector, options)
      input_id = find_field(selector)[:id]
      force_focus('#' + input_id)
      if options.delete(:field_type) == :date
        fill_in_action = proc { fill_in_date_field(selector, options.clone) }
      else
        fill_in_action = proc { fill_in(selector, options.clone) }
      end

      fill_in_action.call
      # Sometimes in combination with the modal Capybara sends its input to the
      # browser's in-page find dialog? Just fill the input in again if this
      # happens.
      fill_in_action.call if find_field(selector).value.blank?
    end

    def should_not_see_modal
      # The modal uses css transitions to fade out, and Capybara has
      # a hard time with this. The backdrop is removed after the modal
      # finishes fading out, so we wait for that event to avoid timing
      # issues.
      expect(page).to_not have_css('.modal')
      expect(page).to_not have_css('.lean-overlay')
    end

    def should_see_modal(title)
      within_modal do
        page.execute_script("$('.modal').scrollTop(0)")
        expect(page).to have_css('.modal__header', text: title)
        yield if block_given?
      end
    end

    def within_modal
      within('.modal') do
        yield if block_given?
      end
    end
  end
end
