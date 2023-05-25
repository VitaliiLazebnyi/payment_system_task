# frozen_string_literal: true

namespace :remove do
  namespace :old do
    desc 'Imports admins and merchants from csv file'
    task transactions: :environment do
      puts 'Removing transactions older then 1 hour...'

      Transaction.where('created_at < ?', 1.hour.ago).destroy_all

      puts 'Removing transactions is done.'
    end
  end
end
