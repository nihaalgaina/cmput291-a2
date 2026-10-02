SELECT ch.account_id, c.sector, SUM(ch.market_value) AS sectorInvestment
FROM CurrentHolding ch
JOIN Stock s   ON s.exg_code = ch.exg_code AND s.ticker = ch.ticker
JOIN Company c ON c.company_id = s.company_id
GROUP BY ch.account_id, c.sector
HAVING SUM(ch.market_value) = (
SELECT MAX(sv)
FROM (SELECT SUM(ch2.market_value) AS sv
FROM CurrentHolding ch2
JOIN Stock s2   ON s2.exg_code = ch2.exg_code AND s2.ticker = ch2.ticker
JOIN Company c2 ON c2.company_id = s2.company_id
WHERE ch2.account_id = ch.account_id
GROUP BY c2.sector))
ORDER BY ch.account_id;

