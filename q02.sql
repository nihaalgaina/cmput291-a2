SELECT exg_code, ticker, ROUND(((close_price - open_price) * 100 / open_price),2) AS percentDiff
FROM MarketPrice
WHERE tday = '2026-09-16'
AND close_price > open_price * 1.05;
