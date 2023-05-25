# frozen_string_literal: true

class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def destroy
    Merchant.find(params[:id]).destroy
    redirect_to merchants_url
  end
end
