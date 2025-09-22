# frozen_string_literal: true

require 'lf7_analyzer'
require_relative '../lib/lf7'

RSpec.describe LF7 do
  it 'returns the correct score for a random grid (array)' do
    lf7 = LF7.new
    score = lf7.compute_score(%w[1 1 N 1 2 1 1])
    expect(score).to eq(26_102)
  end
end
