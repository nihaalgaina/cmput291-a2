SELECT o.order_id, ROUND((julianday(MAX(t.executed_at)) - julianday(MIN(t.executed_at))) * 24, 2) AS fill_hours
FROM Orders o
JOIN Trade t ON t.order_id = o.order_id
GROUP BY o.order_id, o.qty
HAVING SUM(t.qty) = o.qty AND (julianday(MAX(t.executed_at)) - julianday(MIN(t.executed_at))) * 24 > 1;
