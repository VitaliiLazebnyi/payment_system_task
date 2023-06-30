# frozen_string_literal: true

class CreateAuthorizeTransaction
  include UseCase

  attr_reader :params, :transaction

  def initialize(params)
    @params = params.except(:type)
  end

  def perform
    prepare_transaction
    authorize!
    save_transaction
  end

  private

  def prepare_transaction
    @transaction = Authorize.new(params)
  end

  def authorize!
    transaction.merchant.authorize! :create, transaction
  end

  def save_transaction
    transaction.save
  end
end
