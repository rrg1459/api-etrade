puts "03 Creating false tickers..."

TICKERS = [
  {
    "name": "AAPL",
    "asset": "Apple Inc.",
    "asset_type": "Stock",
    "market": "U.S. Stock Market (NASDAQ)"
  },
  {
    "name": "TSLA",
    "asset": "Tesla, Inc.",
    "asset_type": "Stock",
    "market": "U.S. Stock Market (NASDAQ)"
  },
  {
    "name": "AMZN",
    "asset": "Amazon.com Inc.",
    "asset_type": "Stock",
    "market": "U.S. Stock Market (NASDAQ)"
  },
  {
    "name": "EURUSD",
    "asset": "Euro vs. U.S. Dollar",
    "asset_type": "Currency Pair (Forex)",
    "market": "Forex Market"
  },
  {
    "name": "XAUUSD",
    "asset": "Gold vs. U.S. Dollar",
    "asset_type": "Commodity",
    "market": "Commodity Market"
  },
  {
    "name": "BTCUSD",
    "asset": "Bitcoin vs. U.S. Dollar",
    "asset_type": "Cryptocurrency",
    "market": "Cryptocurrency Market"
  },
  {
    "name": "GOOGL",
    "asset": "Alphabet Inc. (Google)",
    "asset_type": "Stock",
    "market": "U.S. Stock Market (NASDAQ)"
  },
  {
    "name": "CL",
    "asset": "Crude Oil (WTI)",
    "asset_type": "Commodity",
    "market": "Futures Market (NYMEX)"
  },
  {
    "name": "JPM",
    "asset": "JPMorgan Chase & Co.",
    "asset_type": "Stock",
    "market": "U.S. Stock Market (NYSE)"
  },
  {
    "name": "SPY",
    "asset": "SPDR S&P 500 ETF",
    "asset_type": "ETF (Exchange-Traded Fund)",
    "market": "U.S. Stock Market (NYSE)"
  }
].freeze

TICKERS.each { |ticker| Ticker.find_or_create_by! ticker }

puts "03 False tickers successfully created"
