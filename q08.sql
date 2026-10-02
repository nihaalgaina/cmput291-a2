SELECT c.sector, ROUND(AVG((last_p.close_price - first_p.close_price) * 100.0 / first_p.close_price), 2) AS avg_return
FROM Stock s
JOIN Company c ON c.company_id = s.company_id
JOIN MarketPrice first_p
ON first_p.exg_code = s.exg_code AND first_p.ticker = s.ticker
AND first_p.tday = (SELECT MIN(tday) FROM MarketPrice m
WHERE m.exg_code = s.exg_code AND m.ticker = s.ticker
AND m.tday >= date('now', '-1 year'))
JOIN MarketPrice last_p
ON last_p.exg_code = s.exg_code AND last_p.ticker = s.ticker
AND last_p.tday = (SELECT MAX(tday) FROM MarketPrice m
WHERE m.exg_code = s.exg_code AND m.ticker = s.ticker
AND m.tday >= date('now', '-1 year'))
GROUP BY c.sector
ORDER BY avg_return DESC;
