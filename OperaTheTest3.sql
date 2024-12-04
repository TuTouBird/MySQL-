# number 1
INSERT INTO supplier ( suppkey, `name`, address, nationkey, phone, acctbal, `COMMENT` )
VALUES
  ( '225392', 'DDD', 'B307', 40, '19932971909', 9999.9, 'FromTest3InsertCommand' );

# number 2
CREATE TABLE customernew(
  custkey int PRIMARY KEY,
  name VARCHAR(25) null,
  address VARCHAR(25) NULL,
  phone CHAR(30) null,
  acctbal DECIMAL(12,2) null,
  mktsegment char(10) null,
  COMMENT VARCHAR(100) null 
);
INSERT INTO customernew(custkey,`name`,address,phone,acctbal,mktsegment,`COMMENT`)
SELECT custkey,`name`,address,phone,acctbal,mktsegment,`COMMENT`
FROM customer
WHERE customer.nationkey = 40;

# number 3
CREATE TABLE cusshopping(
  custkey INT PRIMARY KEY,
  buysnumber INT,
  buysprices INT
);
INSERT INTO cusshopping(custkey, buysnumber,buysprices)
SELECT custkey, SUM(quantity), SUM(lineitem.extendedprice)
FROM orders, lineitem
WHERE lineitem.orderkey = orders.orderkey
GROUP BY custkey;

# number 4
UPDATE partsupp
JOIN supplier ON supplier.suppkey = partsupp.suppkey
SET partsupp.supplycost = 0.8 * partsupp.supplycost
WHERE partsupp.suppkey = (
  SELECT suppkey
  FROM supplier
  WHERE supplier.`name` = '深圳市鸿运贸易有限公司');

# number 5 priority!!!!
UPDATE lineitem
JOIN part ON part.partkey = lineitem.partkey
SET extendedprice = part.retailprice * quantity

# number 6
DELETE FROM lineitem
WHERE orderkey = (
  SELECT orderkey
  FROM orders
  WHERE custkey = (
    SELECT custkey
    FROM customer
    WHERE customer.`name` = '童帅')
);
DELETE FROM orders
WHERE custkey = (
  SELECT custkey
  FROM customer
  WHERE customer.`name` = '童帅');
  
# number 7
DELETE FROM supplier
WHERE supplier.nationkey = (
  SELECT nationkey
  FROM nation
  WHERE nation.`name` = '澳大利亚');
  
# number 8
DELETE FROM customer
WHERE NOT EXISTS (
  SELECT 1
  FROM orders
  WHERE orders.custkey = customer.custkey);

# test for 8
SELECT *
FROM customer
WHERE NOT EXISTS(
  SELECT 1
  FROM orders
  WHERE orders.custkey = customer.custkey);
# test end
