# frozen_string_literal: true

class TransactionsController < ApplicationController
  def index
    authorize! :index, Transaction
    @transactions = Transaction.all.order(:id)
  end
end
