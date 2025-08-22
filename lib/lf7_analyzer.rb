# frozen_string_literal: true

# The LF7Analyzer module provides tools for analyzing LF7 logs.
module LF7Analyzer
  # Application is the main entry point for running analysis tasks.
  class Application
    def open_csv(path)
      CSV.open(path, "r")
    end
  end
end
