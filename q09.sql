CREATE VIEW CurrentHolding (account_id, exg_code, ticker, qty, avg_cost, close_price, market_value) AS
SELECT h.account_id, h.exg_code, h.ticker, h.qty, h.avg_cost, mp.close_price, h.qty * mp.close_price
FROM Holding h
JOIN MarketPrice mp ON mp.exg_code = h.exg_code AND mp.ticker = h.ticker
WHERE mp.tday = (SELECT MAX(tday) FROM MarketPrice m
WHERE m.exg_code = h.exg_code AND m.ticker = h.ticker);
