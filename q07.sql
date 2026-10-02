SELECT h.account_id, c.sector,
       ROUND(SUM(h.qty * mp.close_price) * 100.0 /
             (SELECT SUM(h2.qty * mp2.close_price)
              FROM Holding h2
              JOIN MarketPrice mp2 ON mp2.exg_code = h2.exg_code AND mp2.ticker = h2.ticker
              WHERE h2.account_id = h.account_id
                AND mp2.tday = (SELECT MAX(tday) FROM MarketPrice m
                                WHERE m.exg_code = mp2.exg_code AND m.ticker = mp2.ticker)),
             2) AS pct_invested
FROM Holding h
JOIN Stock s        ON s.exg_code = h.exg_code AND s.ticker = h.ticker
JOIN Company c      ON c.company_id = s.company_id
JOIN MarketPrice mp ON mp.exg_code = h.exg_code AND mp.ticker = h.ticker
WHERE h.qty > 0
  AND mp.tday = (SELECT MAX(tday) FROM MarketPrice m
                 WHERE m.exg_code = mp.exg_code AND m.ticker = mp.ticker)
GROUP BY h.account_id, c.sector
ORDER BY h.account_id, c.sector;
