# frozen_string_literal: true

class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
  end
end
