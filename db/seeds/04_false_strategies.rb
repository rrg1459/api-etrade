puts "04 Creating false strategies..."

STRATEGIES = [
  {
    "name": "Trend Following",
    "description": "Follow the market's trend direction, buying in uptrends and selling in downtrends.",
    "time_frame": "Medium to Long Term (days, weeks, months)",
    "analysis_type": "Technical",
    "ideal_for": "Markets with clear trends. Patient traders."
  },
  {
    "name": "Day Trading",
    "description": "Open and close all positions within the same trading day to avoid overnight risks.",
    "time_frame": "Intraday (minutes, hours)",
    "analysis_type": "Technical",
    "ideal_for": "Full-time traders who can constantly monitor the market."
  },
  {
    "name": "Swing Trading",
    "description": "Capture price movements ('swings') that last for several days or weeks.",
    "time_frame": "Medium Term (days to weeks)",
    "analysis_type": "Technical, Mixed",
    "ideal_for": "Traders with a full-time job who cannot trade all day."
  },
  {
    "name": "Scalping",
    "description": "Execute a high number of quick trades to make small profits on each one.",
    "time_frame": "Very Short Term (seconds to minutes)",
    "analysis_type": "Technical",
    "ideal_for": "Very fast traders with high concentration and low-latency platforms."
  },
  {
    "name": "Breakout Strategy",
    "description": "Enter a trade when the price breaks a significant support or resistance level.",
    "time_frame": "Short to Medium Term",
    "analysis_type": "Technical",
    "ideal_for": "Volatile markets, dynamic traders looking for explosive moves."
  },
  {
    "name": "Mean Reversion",
    "description": "Bet on the price of an asset returning to its average after an extreme move.",
    "time_frame": "Short to Medium Term",
    "analysis_type": "Technical",
    "ideal_for": "Sideways markets or markets with defined ranges."
  },
  {
    "name": "Range Trading",
    "description": "Buy at the low end of a price channel (support) and sell at the high end (resistance).",
    "time_frame": "Short to Medium Term",
    "analysis_type": "Technical",
    "ideal_for": "Markets with well-defined ranges and low directional volatility."
  },
  {
    "name": "News Trading",
    "description": "Trade based on the release of economic news, earnings reports, or geopolitical events.",
    "time_frame": "Very Short Term (minutes)",
    "analysis_type": "Fundamental, Technical",
    "ideal_for": "Traders who react quickly, high volatility."
  },
  {
    "name": "Value Investing",
    "description": "Buy assets considered undervalued by the market and hold them for the long term.",
    "time_frame": "Long Term (months, years)",
    "analysis_type": "Fundamental",
    "ideal_for": "Long-term investors with patience. Warren Buffett's style."
  },
  {
    "name": "Growth Investing",
    "description": "Invest in companies with high growth potential, regardless of their current valuation.",
    "time_frame": "Long Term (months, years)",
    "analysis_type": "Fundamental",
    "ideal_for": "Long-term investors with high risk tolerance."
  }
].freeze

STRATEGIES.each { |strategy| Strategy.find_or_create_by! strategy }

puts "04 False Strategies successfully created"
