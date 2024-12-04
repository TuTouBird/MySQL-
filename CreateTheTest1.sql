CREATE DATABASE test;
USE test;
SHOW TABLES;
CREATE TABLE region(
  regionkey int PRIMARY KEY,
  name CHAR(15) NULL,
  comment VARCHAR(150) NULL
);

CREATE TABLE nation(
  nationkey int PRIMARY KEY,
  name CHAR(15) NULL,
  regionkey int REFERENCES region(regionkey),
  comment VARCHAR(150) NULL
);

CREATE TABLE supplier(
  suppkey int PRIMARY KEY,
  name CHAR(100) NULL,
  address VARCHAR(100) NULL,
  nationkey int REFERENCES nation(nationkey),
  phone char(30) NULL,
  acctbal DECIMAL(12,2) NULL,
  COMMENT VARCHAR(100) NULL
);

CREATE TABLE part(
  partkey int PRIMARY KEY,
  name VARCHAR(100) NULL,
  mfgr CHAR(50) NULL,
  brand CHAR(50) NULL,
  ptype VARCHAR(25) NULL,
  size int NULL,
  container char(10) NULL,
  retailprice DECIMAL(8,2) NULL,
  COMMENT VARCHAR(20) NULL
 );
 
 CREATE TABLE partsupp(
  partkey int REFERENCES part(partkey),
  suppkey int REFERENCES supplier(suppkey),
  availqty int null,
  supplycost DECIMAL(10,2) NULL,
  COMMENT VARCHAR(200) NULL,
  PRIMARY KEY (partkey, suppkey)
 );
 
 CREATE TABLE customer(
  custkey int PRIMARY KEY,
  name VARCHAR(25) null,
  address VARCHAR(25) NULL,
  nationkey int REFERENCES nation(nationkey),
  phone CHAR(30) null,
  acctbal DECIMAL(12,2) null,
  mktsegment char(10) null,
  COMMENT VARCHAR(100) null 
);

CREATE TABLE orders(
  orderkey int PRIMARY KEY,
  custkey int REFERENCES customer(custkey),
  orderstatus char(1) null,
  totalprice DECIMAL(10,2) null,
  orderdate DATE null,
  orderpriority char(15) null,
  clerk CHAR(16) null,
  shippriority char(1) null,
  comment VARCHAR(60) null
); 

CREATE TABLE lineitem(
  orderkey int REFERENCES orders(orderkey),
  partkey int REFERENCES part(partkey),
  suppkey int REFERENCES supplier(suppkey),
  FOREIGN KEY (partkey, suppkey) REFERENCES partsupp(partkey, suppkey),
  linenumber int,
  PRIMARY KEY (orderkey, linenumber),
  quantity int NULL,
  extendedprice DECIMAL(8,2) NULL,
  discount DECIMAL(3,2) NULL,
  tax DECIMAL(3,2) NULL,
  returnflag CHAR(1) NULL,
  linestatus CHAR(1) NULL,
  shipdate date NULL,
  commitdate date NULL,
  receiptdate date NULL,
  shipinstruct CHAR(25) NULL,
  shipmode CHAR(10) NULL,
  COMMENT VARCHAR(40) NULL
);
-- test start
DROP TABLE lineitem;
INSERT INTO lineitem(orderkey, linenumber) VALUES (1,1),(1,2),(2,1),(2,2);
truncate table lineitem;
-- test end
DESCRIBE orders;
CREATE INDEX Dindex ON orders(orderkey);
SHOW INDEX FROM orders;
SHOW INDEX FROM lineitem;
