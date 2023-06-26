# frozen_string_literal: true

class MerchantsController < ApplicationController
  before_action :load_merchant_and_authorize, only: %i[edit update destroy]

  def index
    authorize! :index, Merchant
    @merchants = Merchant.all.order(:id)
  end

  def edit; end

  def update
    generate_flash_with @merchant.update(update_params)
  end

  def destroy
    generate_flash_with @merchant.destroy
    redirect_to merchants_url
  end

  private

  def load_merchant_and_authorize
    @merchant = Merchant.find(params[:id])
    authorize! action_name.to_sym, @merchant
  end

  def update_params
    params.require(:merchant)
          .permit(:name, :description, :email, :active, :total_transaction_sum)
  end
end
