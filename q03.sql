SELECT a.account_id, a.customer_name
FROM Account a
JOIN Holding h ON h.account_id = a.account_id
JOIN Stock s   ON s.exg_code = h.exg_code AND s.ticker = h.ticker
JOIN Company c ON c.company_id = s.company_id
WHERE c.sector = 'Technology'
INTERSECT
SELECT a.account_id, a.customer_name
FROM Account a
JOIN Holding h ON h.account_id = a.account_id
JOIN Stock s   ON s.exg_code = h.exg_code AND s.ticker = h.ticker
JOIN Company c ON c.company_id = s.company_id
WHERE c.sector = 'Financials'
EXCEPT
SELECT a.account_id, a.customer_name
FROM Account a
JOIN Holding h ON h.account_id = a.account_id
JOIN Stock s   ON s.exg_code = h.exg_code AND s.ticker = h.ticker
JOIN Company c ON c.company_id = s.company_id
WHERE c.sector = 'Energy';
