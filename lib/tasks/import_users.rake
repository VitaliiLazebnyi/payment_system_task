# frozen_string_literal: true

namespace :import do
  desc 'Imports admins and merchants from csv file'
  task users: :environment do
    puts 'Importing users...'

    require 'csv'
    raise 'No filename is not defined!' unless ENV['filename']
    raise "The filename doesn't exist!" unless File.exist?(ENV['filename'])

    csv_text = File.read(ENV.fetch('filename', nil))
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      puts "Puts importing user with email '#{row['email']}'..."
      User.create!(row.to_hash)
    end

    puts 'Importing users is done.'
  end
end
