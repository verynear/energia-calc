class SampleGroupDetailPresenter < Decorator
  def base_form
    { sections: [] }
  end

  def form
    base_form.tap do |f|
      f[:sections] += generated_form[:sections]
    end
  end
end
