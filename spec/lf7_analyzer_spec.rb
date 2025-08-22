# frozen_string_literal: true

require 'lf7_analyzer'
require 'csv'

RSpec.describe LF7Analyzer::Application do
  describe '#open_csv' do
    it 'open the csv file without error' do
      app = LF7Analyzer::Application.new
      expect { app.open_csv('data/historical_data.csv') }.not_to raise_error
    end
  end
end
