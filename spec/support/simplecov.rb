# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails' do
  enable_coverage :branch
  primary_coverage :branch
  minimum_coverage line: 90, branch: 90
  add_filter '/spec/'
end
