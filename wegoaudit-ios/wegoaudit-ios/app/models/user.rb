class User < CDQManagedObject
  include CDQRecord

  synchronization_attribute :wegowise_id

  def full_name(reverse = false)
    name_array = [first_name, last_name]
    return name_array.reverse!.compact.join(', ') if reverse
    name_array.compact.join(' ')
  end

  def self.last_logged_in_user
    where(:last_logged_in).ne(nil)
      .sort_by(:last_logged_in, order: :descending)
      .first
  end
end
