# frozen_string_literal: true

class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])
    @merchant.update(update_params)
    redirect_to edit_merchant_url(@merchant)
  end

  def destroy
    Merchant.find(params[:id]).destroy
    redirect_to merchants_url
  end

  private

  def update_params
    params.require(:merchant)
          .permit(:name, :description, :email, :active, :total_transaction_sum)
  end
end
