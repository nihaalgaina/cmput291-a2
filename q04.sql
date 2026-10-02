SELECT exg_code, ticker, volume
FROM MarketPrice
WHERE tday = '2026-09-21'
ORDER BY volume DESC
LIMIT 5;
