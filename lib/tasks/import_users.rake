# frozen_string_literal: true

require 'csv'

namespace :import do
  desc 'Imports admins and merchants from csv file'
  task users: :environment do
    puts 'Importing users...'
    filename = ENV.fetch('filename', nil)

    raise ArgumentError, 'No filename is not defined!' unless filename
    raise ArgumentError, "The filename doesn't exist!" unless File.file?(filename)

    csv_text = File.read(filename)
    csv = CSV.parse(csv_text, headers: true)

    csv.each do |row|
      puts "Puts importing user with email '#{row['email']}'..."
      password = SecureRandom.base36(64)
      User.create!(row.to_hash.merge(password:))
    end

    puts 'Importing users is done.'
  end
end
