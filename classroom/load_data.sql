DROP TABLE IF EXISTS stations;
CREATE TABLE stations (
  stop_id INTEGER PRIMARY KEY,
  direction_id VARCHAR(1) NOT NULL,
  stop_name VARCHAR(70) NOT NULL,
  station_name VARCHAR(70) NOT NULL,
  station_descriptive_name VARCHAR(200) NOT NULL,
  station_id INTEGER NOT NULL,
  "order" INTEGER,
  red BOOLEAN NOT NULL,
  blue BOOLEAN NOT NULL,
  green BOOLEAN NOT NULL
);

COPY stations(
  stop_id,
  direction_id,
  stop_name,
  station_name,
  station_descriptive_name,
  station_id,
  "order",
  red,
  blue,
  green
) FROM '/tmp/cta_stations.csv' DELIMITER ',' CSV HEADER;


DROP TABLE IF EXISTS purchases;
CREATE TABLE purchases(
  id INT PRIMARY KEY,
  username VARCHAR(100),
  currency VARCHAR(10),
  amount INT
);

DROP TABLE IF EXISTS clicks;
CREATE TABLE clicks(
  id INT PRIMARY KEY,
  email VARCHAR(100),
  timestamp VARCHAR(100),
  uri VARCHAR(512),
  number INT
);

DROP TABLE IF EXISTS connect_purchases;
CREATE TABLE connect_purchases(
  id INT PRIMARY KEY,
  username VARCHAR(100),
  currency VARCHAR(10),
  amount INT
);

DROP TABLE IF EXISTS connect_clicks;
CREATE TABLE connect_clicks(
  id INT PRIMARY KEY,
  email VARCHAR(100),
  timestamp VARCHAR(100),
  uri VARCHAR(512),
  number INT
);

COPY purchases(
  id,
  username,
  currency,
  amount
) FROM '/tmp/purchases.csv' DELIMITER ',' CSV HEADER;

COPY clicks(
  id,
  email,
  timestamp,
  uri,
  number
)  FROM '/tmp/clicks.csv' DELIMITER ',' CSV HEADER;
