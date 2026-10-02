PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE CurrentHolding(
  account_id INTEGER,
  exg_code TEXT,
  ticker TEXT,
  qty INTEGER,
  avg_cost REAL,
  close_price REAL,
  market_value REAL
);
INSERT INTO CurrentHolding VALUES (1, 'NYSE', 'TA', 300, 8.0, 10.0, 3000.0);
INSERT INTO CurrentHolding VALUES (1, 'NYSE', 'FA', 150, 18.0, 20.0, 3000.0);
INSERT INTO CurrentHolding VALUES (2, 'NASDAQ', 'TB', 200, 22.0, 25.0, 5000.0);
INSERT INTO CurrentHolding VALUES (2, 'TSX', 'EA', 40, 45.0, 50.0, 2000.0);
INSERT INTO CurrentHolding VALUES (3, 'TSX', 'EA', 20, 47.0, 50.0, 1000.0);
INSERT INTO CurrentHolding VALUES (5, 'NYSE', 'TA', -100, 9.0, 10.0, -1000.0);
INSERT INTO CurrentHolding VALUES (5, 'NYSE', 'FA', -25, 21.0, 20.0, -500.0);
INSERT INTO CurrentHolding VALUES (6, 'NYSE', 'TA', 250, 7.5, 10.0, 2500.0);
INSERT INTO CurrentHolding VALUES (6, 'NASDAQ', 'TB', 60, 23.0, 25.0, 1500.0);
INSERT INTO CurrentHolding VALUES (6, 'LSE', 'HA', 100, 38.0, 40.0, 4000.0);
INSERT INTO CurrentHolding VALUES (6, 'NYSE', 'FA', 50, 19.0, 20.0, 1000.0);
COMMIT;
