# frozen_string_literal: true

class UseCase
  include Dry::Transaction

  class << self
    def call(**args)
      new.call(**args)
    end
  end
end
