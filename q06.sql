SELECT exg_code, ticker, COUNT(*) AS numAccounts
FROM Holding
GROUP BY exg_code, ticker
HAVING COUNT(*) = (SELECT MAX(cnt)
FROM (SELECT COUNT(*) AS cnt
FROM Holding
GROUP BY exg_code, ticker));
