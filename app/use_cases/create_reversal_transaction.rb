# frozen_string_literal: true

class CreateReversalTransaction
  include UseCase

  attr_reader :user, :params, :transaction

  def initialize(user, params)
    @user = user
    @params = params.except(:type)
  end

  def perform
    ActiveRecord::Base.transaction do
      load_authorize_transaction
      prepare_transaction
      authorize!
      save_transaction
      invalidate_authorize_transaction
    end
  end

  private

  def load_authorize_transaction
    @authorize = Authorize.find(params[:reference_id])
    params.merge!(reference: @authorize)
  rescue ActiveRecord::RecordNotFound
    save_error('Reference not found')
  end

  def prepare_transaction
    @transaction = Reversal.new(params)
  end

  def authorize!
    user.authorize! :create, transaction
  end

  def save_transaction
    transaction.valid?
    save_errors(transaction.errors.full_messages)
    transaction.save(validate: false)
  end

  def invalidate_authorize_transaction
    return false if errors?

    @authorize.update!(status: :reversed)
  end
end
