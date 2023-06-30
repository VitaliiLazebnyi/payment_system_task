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
    !errors || errors.empty?
  end

  def errors
    @errors ||= []
    @errors
  end

  def errors=(e)
    @errors = e
  end

  def errors?
    !success?
  end

  def save_error(e)
    errors.push(e)
  end

  def save_errors(e)
    return if !e || e.empty?
    self.errors += e
  end
end
