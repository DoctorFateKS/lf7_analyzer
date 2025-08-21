# frozen_string_literal: true

require 'lf7_analyzer'

RSpec.describe LF7Analyzer::Application do
  it 'dit bonjour' do
    expect { subject.run }.to output("Hello, this is the LF7 Analyzer\n").to_stdout
  end
end
