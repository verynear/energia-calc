module ApplicationHelper
  def link_to_delete_object(object)
    object_param = object.is_a?(Audit) ? object : [current_audit, object]
    link_to(object_param,
            method: :delete,
            class: 'delete-query__yes js-delete-query-yes') do
      'Delete <i class="icon-check"></i>'.html_safe
    end
  end

  def title(text)
    content_for(:page_title) { text }
  end

  # def page_title
  #   @page_title
  # end
end
