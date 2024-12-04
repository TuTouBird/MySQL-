# number 1
CREATE VIEW Viewpart1
AS
SELECT partsupp.suppkey, supplier.`name` supplierName,part.partkey, part.`name` partName,availqty,retailprice,supplycost
FROM part, partsupp,supplier
WHERE part.partkey = partsupp.partkey AND supplier.suppkey = partsupp.suppkey AND supplier.suppkey = (
  SELECT suppkey
  FROM supplier
  WHERE supplier.`name` = '河北省华信集团');
  
# number 2
DROP VIEW viewcust1;
CREATE VIEW ViewCust1
AS
SELECT customer.custkey, customer.`name`, SUM(extendedprice), SUM(quantity)
FROM customer, orders, lineitem
WHERE customer.custkey = orders.custkey AND orders.orderkey = lineitem.orderkey AND YEAR(orders.orderdate) = 2024
GROUP BY customer.custkey;

# number 2.1 must be failure
INSERT INTO ViewCust1 VALUES (225392,'DDD',999,999);
# number 2.2 
SELECT *
FROM ViewCust1
WHERE ViewCust1.`SUM(extendedprice)` > 100000

# number 3
CREATE VIEW Viewpart2
AS
SELECT partsupp.partkey, partsupp.suppkey, partsupp.availqty, partsupp.supplycost
FROM partsupp
WHERE partsupp.suppkey = (
  SELECT suppkey
  FROM supplier
  WHERE supplier.`name` = '河北钢铁集团有限公司');

INSERT INTO Viewpart2 VALUES(20040210,24706,100,99);
UPDATE Viewpart2
SET supplycost = 111
WHERE partkey = 20040210;
DELETE FROM Viewpart2
WHERE supplycost = 111;

# number 4
CREATE VIEW Viewpart3
AS
SELECT partsupp.partkey, partsupp.suppkey, partsupp.availqty, partsupp.supplycost
FROM partsupp
WHERE partsupp.suppkey = (
  SELECT suppkey
  FROM supplier
  WHERE supplier.`name` = '河北钢铁集团有限公司')
WITH CHECK OPTION;

INSERT INTO Viewpart3 VALUES(20040210,24706,100,99);
INSERT INTO Viewpart3 VALUES(20040210,24707,100,99);  # failure
UPDATE Viewpart3
SET supplycost = 111
WHERE partkey = 20040210;
DELETE FROM Viewpart3
WHERE supplycost = 111;

# number 5
DROP VIEW Viewcust2;
CREATE VIEW Viewcust2
AS
SELECT customer.custkey, customer.`name`, SUM(extendedprice) price, SUM(quantity) quantity
FROM customer, orders, lineitem
WHERE customer.custkey = orders.custkey AND orders.orderkey = lineitem.orderkey
GROUP BY customer.custkey;
# number 5.1
CREATE VIEW Viewcust3
AS
SELECT Viewcust2.custkey, Viewcust2.`name`, Viewcust2.price/count(*) avg_price, Viewcust2.quantity/count(*) avg_quantity
FROM Viewcust2
GROUP BY custkey;
# number 5.2
DROP VIEW Viewcust2;

