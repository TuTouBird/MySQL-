update orders SET orderdate=DATE_ADD(orderdate, INTERVAL 3 year);
update lineitem SET partkey=65483,suppkey=20368 WHERE orderkey=6084 and linenumber=2;

# number 1
SELECT regionkey, `name` FROM region;
# number 2
# test start
SELECT suppkey,`name`, nationkey FROM supplier;
# test end
SELECT suppkey, supplier.`name`, address, phone, nation.`name` NationName
FROM supplier, nation
WHERE supplier.nationkey = nation.nationkey;

# number 3 
SELECT orderkey, customer.`name`, nation.`name` NationName, orderdate
FROM orders, customer, nation
WHERE totalprice > 10000 AND YEAR(orderdate) = 2024 AND MONTH(orderdate) = 9 AND
      orders.custkey = customer.custkey AND customer.nationkey = nation.nationkey;
      
# number 4 
SELECT orders.custkey, customer.`name`, SUM(totalprice) total_amount
FROM orders,customer
WHERE orders.custkey = customer.custkey AND YEAR(orderdate) = 2024
GROUP BY orders.custkey

# number 5 but 1000000 change to 10000
SELECT part.partkey, part.`name`, part.brand, mfgr, SUM(totalprice)
FROM lineitem, part, orders
WHERE lineitem.partkey = part.partkey AND lineitem.orderkey = orders.orderkey
GROUP BY part.partkey
HAVING SUM(totalprice) > 10000;

# number 6 but 1000000 change to 100000 and 2023 change to 2020
SELECT lineitem.suppkey,supplier.`name`,SUM(totalprice)
FROM lineitem,supplier,orders
WHERE lineitem.orderkey = orders.orderkey AND lineitem.suppkey = supplier.suppkey AND YEAR(orderdate) = 2023
GROUP BY supplier.suppkey
HAVING SUM(totalprice) > 100000;

# number 7
SELECT orders.custkey, customer.`name`, AVG(orders.totalprice)
FROM orders, customer
WHERE orders.custkey = customer.custkey
GROUP BY orders.custkey
HAVING AVG(totalprice) > 50000;

# number 8
SELECT supplier.suppkey, supplier.`name`, supplier.address
FROM supplier
WHERE nationkey = 
          (SELECT nationkey
          FROM supplier
          WHERE `name` = '金石印刷有限公司');
      

# number 9
SELECT part.partkey, part.`name`, part.mfgr, part.brand, retailprice, supplier.`name` supplierName, supplycost
FROM part, supplier, partsupp
WHERE part.partkey = partsupp.partkey AND partsupp.suppkey = supplier.suppkey AND
supplycost < retailprice;

# number 10
SELECT orders.orderkey, orders.totalprice, lineitem.partkey, quantity, extendedprice
FROM orders, customer, lineitem
WHERE orders.custkey = customer.custkey AND customer.`name` = '曹玉书'

# number 11
SELECT customer.custkey, customer.`name`
FROM lineitem, customer, part, orders
WHERE part.partkey = lineitem.partkey AND lineitem.orderkey = orders.orderkey AND customer.custkey  = orders.custkey AND part.mfgr = '南昌矿山机械厂' AND part.`name` = '缝盘机';

# number 12
SELECT customer.custkey, customer.`name`
FROM customer, orders
WHERE orders.custkey = customer.custkey AND customer.nationkey = 40
GROUP BY customer.custkey
HAVING AVG(totalprice) > 10000;

# number 13 add {21101 440474} to orders, add {21101 26360 _ 1} to lineitem
SELECT part.`name`, part.partkey, part.brand, part.container, part.mfgr, part.retailprice
FROM part,customer,orders,lineitem
WHERE lineitem.partkey = part.partkey AND orders.custkey = customer.custkey AND lineitem.orderkey = orders.orderkey AND customer.`name` = '刘玉龙'  AND lineitem.partkey IN (SELECT part.partkey
                    FROM part,customer,orders,lineitem
                    WHERE lineitem.partkey = part.partkey AND orders.custkey = customer.custkey AND customer.`name` = '钱岚' AND lineitem.orderkey = orders.orderkey)

# number 14
SELECT DISTINCT part.`name`, part.partkey, part.brand, part.container, part.mfgr, part.retailprice
FROM part,customer,orders,lineitem
WHERE lineitem.partkey = part.partkey AND orders.custkey = customer.custkey AND lineitem.orderkey = orders.orderkey  AND (customer.`name` = '刘玉龙' OR customer.`name` = '钱岚' )

# number 15
SELECT part.`name`, part.partkey, part.brand, part.container, part.mfgr, part.retailprice
FROM part,customer,orders,lineitem
WHERE lineitem.partkey = part.partkey AND orders.custkey = customer.custkey AND lineitem.orderkey = orders.orderkey AND customer.`name` = '刘玉龙'  AND lineitem.partkey NOT IN (SELECT part.partkey
                    FROM part,customer,orders,lineitem
                    WHERE lineitem.partkey = part.partkey AND orders.custkey = customer.custkey AND customer.`name` = '钱岚' AND lineitem.orderkey = orders.orderkey)

# test start
SELECT part.`name`, part.partkey, linenumber, lineitem.orderkey, customer.`name`,customer.custkey
FROM part,customer,orders,lineitem
WHERE lineitem.partkey = part.partkey AND orders.custkey = customer.custkey AND lineitem.orderkey = orders.orderkey  AND (customer.`name` = '刘玉龙' OR customer.`name` = '钱岚' )
# test end
