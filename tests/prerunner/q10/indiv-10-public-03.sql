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
INSERT INTO CurrentHolding VALUES (21, 'NASDAQ', 'VRTX', 180, 30.0, 50.0, 9000.0);
INSERT INTO CurrentHolding VALUES (21, 'NYSE', 'ZEPH', 100, 600.0, 90.0, 9000.0);
INSERT INTO CurrentHolding VALUES (21, 'NYSE', 'YARD', 100, 450.0, 40.0, 4000.0);
INSERT INTO CurrentHolding VALUES (21, 'TSX', 'ANVL', 50, 4.0, 45.0, 2250.0);
INSERT INTO CurrentHolding VALUES (21, 'LSE', 'BCON', 500, 500.0, 1.0, 500.0);
INSERT INTO CurrentHolding VALUES (22, 'NASDAQ', 'VRTX', 40, 25.0, 50.0, 2000.0);
INSERT INTO CurrentHolding VALUES (22, 'NASDAQ', 'WAVE', 150, 350.0, 20.0, 3000.0);
INSERT INTO CurrentHolding VALUES (22, 'TSX', 'XYLM', 50, 2.5, 100.0, 5000.0);
INSERT INTO CurrentHolding VALUES (22, 'NYSE', 'ZEPH', 111, 650.0, 90.0, 9990.0);
INSERT INTO CurrentHolding VALUES (23, 'TSX', 'ANVL', 100, 4.5, 45.0, 4500.0);
INSERT INTO CurrentHolding VALUES (24, 'NYSE', 'YARD', 100, 480.0, 40.0, 4000.0);
INSERT INTO CurrentHolding VALUES (24, 'LSE', 'YARD', 100, 3.5, 30.0, 3000.0);
INSERT INTO CurrentHolding VALUES (25, 'LSE', 'BCON', 100, 550.0, 1.0, 100.0);
COMMIT;
