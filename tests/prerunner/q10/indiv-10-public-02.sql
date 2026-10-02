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
INSERT INTO CurrentHolding VALUES (11, 'NASDAQ', 'NIMB', 200, 250.0, 30.0, 6000.0);
INSERT INTO CurrentHolding VALUES (11, 'NYSE', 'ORIO', 150, 35.0, 40.0, 6000.0);
INSERT INTO CurrentHolding VALUES (11, 'TSX', 'PETR', 300, 18.0, 20.0, 6000.0);
INSERT INTO CurrentHolding VALUES (12, 'NASDAQ', 'NIMB', 100, 260.0, 30.0, 3000.0);
INSERT INTO CurrentHolding VALUES (12, 'TSX', 'PETR', 200, 19.0, 20.0, 4000.0);
INSERT INTO CurrentHolding VALUES (13, 'TSX', 'ORIO', 0, 60.0, 25.0, 0.0);
INSERT INTO CurrentHolding VALUES (13, 'NYSE', 'ORIO', -50, 38.0, 40.0, -2000.0);
INSERT INTO CurrentHolding VALUES (14, 'LSE', 'QSAR', 100, 7.0, 9.0, 900.0);
COMMIT;
