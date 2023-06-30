# frozen_string_literal: true

class CreateReversalTransaction
  include UseCase

  attr_reader :params, :transaction

  def initialize(params)
    @params = params.except(:type)
  end

  def perform
    load_authorize_transaction
    prepare_transaction
    authorize!
    save_transaction
    invalidate_authorize_transaction
  end

  private

  def load_authorize_transaction
    @authorize   = Authorize.find(params[:reference_id])
    params.merge!(reference: @authorize)
  end

  def prepare_transaction
    @transaction = Reversal.new(params)
  end

  def authorize!
    merchant = Merchant.find(params[:merchant_id])
    merchant.authorize! :create, transaction
  end

  def save_transaction
    # require 'pry'; binding.pry
    transaction.save!
  end

  def invalidate_authorize_transaction
    # require 'pry'; binding.pry
    @authorize.update!(status: :reversed)
  end
end
