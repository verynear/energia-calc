class NewAuditController < Formotion::FormController
  include BaseController
  include DisableContentReadableMargins

  attr_reader :form

  def initController
    initWithForm(NewAuditForm.new)
  end

  def viewDidLoad
    super

    form.sections.each do |section|
      section.rows.each do |row|
        row.on_end do
          row.object.validate!
        end
      end
    end

    navigationItem.leftBarButtonItem = UIBarButtonItem.alloc
      .initWithBarButtonSystemItem(UIBarButtonSystemItemCancel,
                                   target: self,
                                   action: 'dismiss_modal')
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc
      .initWithBarButtonSystemItem(UIBarButtonSystemItemSave,
                                   target: self,
                                   action:'create_audit')
  end

  def create_audit
    form.sections.each do |section|
      section.rows.each do |row|
        row.object.validate!
      end
    end

    if valid?
      CreateAuditService.execute!(audit: form.render, user: current_user)
      cdq.save
      dismiss_modal
    end
  end

  def valid?
    form.sections.all? do |section|
      section.rows.all? do |row|
        row.object.valid?
      end
    end
  end

  def dismiss_modal
    self.navigationController.popViewControllerAnimated(self)
  end
end
