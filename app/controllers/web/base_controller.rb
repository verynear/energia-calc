module Web
  class BaseController < SecuredController
    helper_method :current_audit

    private

    def current_audit
      return nil unless params[:audit_id]
      @current_audit ||= Audit.find(params[:audit_id])
    end

    def redirect_to_parent(audit_structure, options = {})
      if audit_structure.parent_object.audit
        redirect_to current_audit, options
      else
        redirect_to [current_audit, audit_structure.parent_object], options
      end
    end
  end
end
