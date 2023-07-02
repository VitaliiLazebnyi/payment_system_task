# frozen_string_literal: true

module UseCase
  extend ActiveSupport::Concern

  module ClassMethods
    # The perform method of a UseCase should always return itself
    def perform(*args)
      new(*args).tap(&:perform)
    end
  end

  # implement all the steps required to complete this use case
  def perform
    raise NotImplementedError
  end

  # inside of perform, add errors if the use case did not succeed
  def success?
    errors.blank?
  end

  def errors
    @errors ||= []
    @errors
  end

  def errors=(errors)
    @errors = errors
  end

  def errors?
    !success?
  end

  def save_error(error)
    errors.push(error)
  end

  def save_errors(errors)
    return if errors.blank?

    self.errors += errors
  end
end
