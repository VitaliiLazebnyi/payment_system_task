# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Admin.create!(name: 'Admin', password: SecureRandom.base36(64), description: 'admin', email: 'admin@email.com')
merchant = Merchant.create!(name: 'Merchant', password: SecureRandom.base36(64), description: 'merchant',
                            email: 'merchant@email.com')
Authorize.create!(merchant:, customer_email: merchant.email, customer_phone: '+38093123456789', amount: 1)
