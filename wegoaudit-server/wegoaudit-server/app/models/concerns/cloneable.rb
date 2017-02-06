# Create a clone of an ActiveRecord model, using all of the same attributes
# _except_ for the ones that are not cloneable.
#
# Unlike the built-in ActiveRecord::Base#clone method, this does not just
# create an in-memory copy of the record and it DOES dup the attributes.
module Cloneable
  extend ActiveSupport::Concern

  def create_clone(params = {})
    self.class.create(cloneable_attributes(params))
  end

  def cloneable_attributes(params = {})
    params['cloned'] = true if respond_to?(:cloned)
    attributes.dup.except(*excluded_attributes).merge(params)
  end

  def excluded_attributes
    [
      'id',
      'successful_upload_on',
      'upload_attempt_on',
      'created_at',
      'updated_at'
    ]
  end
end
