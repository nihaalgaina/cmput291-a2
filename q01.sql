SELECT DISTINCT c.company_id, c.name
FROM Company c
JOIN Stock s1 ON s1.company_id = c.company_id
JOIN Stock s2 ON s2.company_id = c.company_id
WHERE s1.exg_code != s2.exg_code;
