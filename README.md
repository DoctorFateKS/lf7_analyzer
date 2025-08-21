# Lotofoot 7 Analyzer

**Version:** 1.0  
**Status:** WIP (Work in Progress)  
**License:** MIT  

---

## 📖 Overview

The **Lotofoot 7 Analyzer** is a Ruby-based tool designed to analyze the French betting game **Lotofoot 7** using historical data (manually stored in CSV, not scraped).  
Its purpose is to evaluate all possible **2,187 simple grids (1 sign per match)**, compute their probabilities of success, expected value (EV), and backtest strategies over historical draws.

The project starts as a **Ruby library + CLI tool** and may evolve into a **Rails-based web UI** for richer visualizations and comparisons.

---

## 🎯 Features

- Import and normalize historical draws from **CSV** (no scraping required).
- Compute probabilities for each match using configurable methods:
  - Long-term frequency
  - Rolling window frequency
  - Exponential decay
  - Gap heuristics
- Evaluate all **2,187 possible grids** with:
  - Probability of 7/7
  - Probability of 6/7
  - Expected value (EV) based on historical payouts
- Perform **walk-forward backtesting** to measure realistic historical performance.
- Export results and backtests to **CSV/JSON**.
- (Future) **Rails UI** with charts, dashboards, and strategy comparison.

---

## 🏗 Project Structure

```bash
lotofoot7-analyzer/
├── data/                 # Input data (CSV files with historical draws)
│   └── draws_sample.csv
├── lib/                  # Core Ruby library code
│   └── lotofoot7/
│       ├── version.rb
│       ├── draw.rb
│       ├── estimator.rb
│       ├── grid_engine.rb
│       ├── backtester.rb
│       └── ...
├── spec/                 # RSpec tests
│   ├── spec_helper.rb
│   └── lotofoot7/
│       └── draw_spec.rb
├── bin/                  # CLI executables
│   └── lotofoot7         # Main CLI entrypoint
├── README.md             # Project documentation
├── Gemfile
└── Rakefile
```

## 📦 Installation

1. Clone the repository:
```bash
git clone https://github.com/<your-username>/lotofoot7-analyzer.git
cd lotofoot7-analyzer
```

2. Install dependencies:
```bash
bundle install
```

3. Run tests to ensure setup is correct:
```bash
bundle exec rspec
```

## ⚡ Usage

1. Prepare data
Place your historical draws as a CSV file in the data/ folder.
Example format:
```bash
date,r1,r2,r3,r4,r5,r6,r7
2023-05-14,1,2,N,1,1,2,N
2023-05-21,2,N,1,1,2,N,1
...
```

2. Run CLI
```bash
bin/lotofoot7 scrape       # (optional) load CSV into DB
bin/lotofoot7 stats        # compute frequencies & stats
bin/lotofoot7 evaluate     # evaluate all 2187 grids
bin/lotofoot7 backtest     # run walk-forward backtest
bin/lotofoot7 export       # export results to CSV/JSON
```

## 📊 Roadmap

 Define architecture & data model

 CSV ingestion + Draw model

 Probability estimators

 Grid evaluation (P7, P6, EV)

 Walk-forward backtester

 CLI commands (scrape, stats, evaluate, backtest, export)

 Rails UI (dashboard, charts, strategy configs)

 ## ⚠️ Disclaimer

 This project is for **research and educational purposes only**.
It does **not encourage or promote gambling**.
Use of this software is entirely at your own risk.

 ## 🤝 Contributing
 
Pull requests are welcome!
For major changes, please open an issue first to discuss what you would like to change.

## 📜 License

This project is licensed under the **MIT License**.
