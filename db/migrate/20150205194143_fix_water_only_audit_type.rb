class FixWaterOnlyAuditType < ActiveRecord::Migration
  class AuditType < ActiveRecord::Base; end

  def up
    if audit_type = AuditType.find_by(name: 'Water Only ')
      audit_type.name = 'Water Only'
      audit_type.save!
    end
  end

  def down
    if audit_type = AuditType.find_by(name: 'Water Only')
      audit_type.name = 'Water Only '
      audit_type.save!
    end
  end
end
