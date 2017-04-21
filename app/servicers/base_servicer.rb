class BaseServicer < Generic::Strict
  include Memoizer

  def self.execution_errors_to_rescue
    [ActiveRecord::RecordInvalid]
  end

  def self.execute!(*args)
    servicer_attributes = args.shift
    new(servicer_attributes).execute!(*args)
  end

  def self.execute(*args)
    servicer_attributes = args.shift
    new(servicer_attributes).execute(*args)
  end

  def execute(*args)
    execute!(*args)
    true
  rescue *self.class.execution_errors_to_rescue
    false
  end

  def execute!(*)
    # The including class should implement this method
    raise NotImplementedError
  end
end
