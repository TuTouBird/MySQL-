#列级约束有六种：主键Primary key、外键foreign key 、唯一 unique、检查 checck 、默认default 、非空/空值 not null/ null
#表级约束有四种：主键、外键、唯一、检查

CREATE TABLE supplier(
  suppkey int PRIMARY KEY,
  name CHAR(100) NULL,
  address VARCHAR(100) NULL,
  nationkey int REFERENCES nation(nationkey),
  phone char(30) NULL,
  acctbal DECIMAL(12,2) NULL,
  COMMENT VARCHAR(100) NULL
);

# number 1
CREATE TABLE Supplier1 (
  suppkey INT PRIMARY KEY, 
  name CHAR(100) NULL, 
  address VARCHAR(100) NULL, 
  nationkey INT, 
  phone CHAR(30) NULL,
  acctbal DECIMAL(12,2) NULL,
  COMMENT VARCHAR(100) NULL,
  CONSTRAINT fk_nation FOREIGN KEY (nationkey) REFERENCES nation(nationkey) 
);
# number 2
CREATE TABLE Supplier2 (
  suppkey INT,
  name CHAR(100) NULL,
  address VARCHAR(100) NULL,
  nationkey INT,
  phone CHAR(30) NULL,
  acctbal DECIMAL(12,2) NULL,
  COMMENT VARCHAR(100) NULL,
  CONSTRAINT pk_suppkey PRIMARY KEY (suppkey), 
  CONSTRAINT fk_nation2 FOREIGN KEY (nationkey) REFERENCES nation(nationkey) 
);
# number 3
CREATE TABLE Supplier3 (
  suppkey INT,
  name CHAR(100) NULL,
  address VARCHAR(100) NULL,
  nationkey INT,
  phone CHAR(30) NULL,
  acctbal DECIMAL(12,2) NULL,
  COMMENT VARCHAR(100) NULL
);

ALTER TABLE Supplier3
ADD CONSTRAINT pk_suppkey3 PRIMARY KEY (suppkey);
ALTER TABLE Supplier3
ADD CONSTRAINT fk_nation3 FOREIGN KEY (nationkey) REFERENCES nation(nationkey);

# number 4
CREATE TABLE partsupp1(
  partkey int,
  suppkey int,
  availqty int null,
  supplycost DECIMAL(10,2) NULL,
  COMMENT VARCHAR(200) NULL,
  PRIMARY KEY (partkey, suppkey)
 );
ALTER TABLE partsupp1
ADD CONSTRAINT fk_partkey1 FOREIGN KEY (partkey) REFERENCES part(partkey);
ALTER TABLE partsupp1
ADD CONSTRAINT fk_suppkey1 FOREIGN KEY (suppkey) REFERENCES supplier(suppkey);
 
 # number 5
 CREATE TABLE nation1(
  nationkey int,
  `name` CHAR(15),
  regionkey int,
  comment VARCHAR(150) NULL
);
ALTER TABLE nation1
ADD CONSTRAINT fk_regionkey1 FOREIGN KEY (regionkey) REFERENCES region(regionkey);
ALTER TABLE nation1
ADD CONSTRAINT pk_nationkey1 PRIMARY KEY (nationkey);
ALTER TABLE nation1
ADD CONSTRAINT uq_name UNIQUE (`name`);
 
 # number 6
INSERT INTO nation1(nationkey,`name`,regionkey) VALUES (225392, '赛博坦', 1);
 
 # number 7
ALTER TABLE nation1 DROP PRIMARY KEY;

# number 8
CREATE TABLE region1(
  regionkey int,
  name CHAR(15) NULL,
  comment VARCHAR(150) NULL,
  CONSTRAINT pk_regionkey PRIMARY KEY (regionkey)
);
 CREATE TABLE nation2(
  nationkey int PRIMARY KEY,
  `name` CHAR(15) NOT NULL,
  regionkey int,
  comment VARCHAR(150) NULL,
  CONSTRAINT fk_regionkey2 FOREIGN KEY (regionkey) REFERENCES region1(regionkey)
);
 CREATE TABLE nation3(
  nationkey int,
  `name` CHAR(15) NOT NULL,
  regionkey int,
  comment VARCHAR(150) NULL,
  CONSTRAINT pk_nationkey3 PRIMARY KEY(nationkey),
  CONSTRAINT fk_regionkey3 FOREIGN KEY (regionkey) REFERENCES region1(regionkey)
);

# number 9
CREATE TABLE lineitem1(
  orderkey int,
  partkey int,
  suppkey int,
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

ALTER TABLE lineitem1 
ADD CONSTRAINT fk_orderkey1 FOREIGN KEY (orderkey) REFERENCES orders(orderkey);
ALTER TABLE lineitem1
ADD CONSTRAINT fk_partkey2 FOREIGN KEY (partkey) REFERENCES part(partkey);
ALTER TABLE lineitem1
ADD CONSTRAINT fk_suppkey2 FOREIGN KEY (suppkey) REFERENCES supplier(suppkey);
ALTER TABLE lineitem1
ADD CONSTRAINT fk_union_lineitem1 FOREIGN KEY (partkey, suppkey) REFERENCES partsupp(partkey, suppkey);

# number 10
ALTER TABLE nation3 DROP FOREIGN KEY fk_regionkey3;
# number 11
INSERT INTO nation3(nationkey,`name`,regionkey) VALUES(225392, '赛博坦', 99999);

# number 12
CREATE TABLE nation4 (
  nationkey INT PRIMARY KEY,
  name CHAR(100) NOT NULL,
  regionkey INT DEFAULT 0, 
  CONSTRAINT fk_regionkey4 FOREIGN KEY (regionkey) REFERENCES region(regionkey)
);

# number 13
CREATE TABLE lineitem2(
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
ALTER TABLE lineitem2
ADD CONSTRAINT `date` CHECK (shipdate < receiptdate);
ALTER TABLE lineitem2
ADD CONSTRAINT flag CHECK (returnflag IN ('A', 'R', 'N'));

# number 14
ALTER TABLE Lineitem2
DROP FOREIGN KEY lineitem2_ibfk_1;

ALTER TABLE lineitem2
MODIFY partkey INT NOT NULL;
ALTER TABLE lineitem2
MODIFY suppkey INT NOT NULL;

ALTER TABLE lineitem2
ADD CONSTRAINT union2 FOREIGN KEY (partkey, suppkey) REFERENCES partsupp(partkey, suppkey);

-- test start
SELECT
  CONSTRAINT_NAME,
  TABLE_NAME,
  COLUMN_NAME,
  REFERENCED_TABLE_NAME,
  REFERENCED_COLUMN_NAME
FROM
  INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE
  TABLE_NAME = 'Lineitem2'
-- test end

# number 15
INSERT INTO lineitem2(orderkey,partkey,suppkey,shipdate,receiptdate,returnflag)
VALUES (225392,NULL,225392, '2004-02-10','2024-10-24','O');
INSERT INTO lineitem2(orderkey,partkey,suppkey,shipdate,receiptdate,returnflag,linenumber)
VALUES (1,44930,18848, '2004-02-10','2024-10-24','A',1);
INSERT INTO lineitem2(orderkey,partkey,suppkey,shipdate,receiptdate,returnflag,linenumber)
VALUES (1,1,1, '2024-10-24','2004-02-10','A',1);

