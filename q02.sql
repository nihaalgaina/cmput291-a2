SELECT exg_code, ticker, ((close_price - open_price) * 100 / open_price) AS percentDiff
FROM MarketPrice
WHERE tday = '2026-09-21'
AND close_price > open_price * 1.05;
