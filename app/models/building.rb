class Building < ActiveRecord::Base
  include Cloneable,
          SoftDestruction

  has_many :apartments
  has_many :organization_buildings
  has_many :organizations, through: :organization_buildings
  has_many :meters, as: :audit_structure
  has_one :audit_structure, as: :physical_structure

  def self.create_temporary!(wego_id, name)
      create!(wegowise_id: wego_id,
              street_address: 'Temporary',
              city: 'Temporary',
              state_code: 'ty',
              zip_code: 'Temporary',
              draft: true,
              nickname: name,
              cloned: false,
              object_type: 'Temporary')
  end

  def self.search_by_name(name)
    return [] unless name.present?
    where(cloned: false)
      .where.not(wegowise_id: nil)
      .where('nickname ILIKE ?', "%#{name}%")
      .order(:nickname)
  end

  def self.audit_strc_type
    AuditStrcType.find_by(physical_structure_type: 'Building')
  end

  def linked?
    wegowise_id.to_i != 0
  end

  def name=(new_name)
    self.nickname = new_name
  end

  def name
    nickname
  end

  def short_description
    desc = []
    desc << building_type.capitalize if building_type
    desc << nickname
    desc.compact.join(' - ')
  end
end
