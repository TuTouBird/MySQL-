-- number 1
CREATE PROCEDURE proc1()
BEGIN
  UPDATE lineitem 
  JOIN part ON part.partkey = lineitem.partkey
  SET extendedprice = (quantity * retailprice) * (1 - discount) * (1+ tax);
  
  UPDATE orders
  SET totalprice = (
    SELECT SUM(extendedprice)
    FROM lineitem
    WHERE lineitem.orderkey = orders.orderkey
  );
  
END
DROP PROCEDURE proc1;

ALTER TABLE lineitem
MODIFY COLUMN extendedprice DECIMAL(20, 2);

call proc1();

-- number 2
CREATE PROCEDURE proc2(in inputkey INT)
BEGIN
    UPDATE orders
    SET totalprice = (
        SELECT SUM((quantity * retailprice) * (1 - discount) * (1+ tax))
        FROM lineitem, part
        WHERE lineitem.partkey = part.partkey AND lineitem.orderkey = inputkey
    )
    WHERE orders.orderkey = inputkey;
END;


DROP PROCEDURE proc2;

CALL proc2(1);

-- number 3
CREATE PROCEDURE proc3(IN inputKey INT)
BEGIN
    DECLARE orderKey INT;
    
    -- 获取订单键
    SELECT orderkey INTO orderKey
    FROM orders
    WHERE custkey = inputKey
    LIMIT 1;
    
    -- 更新扩展价格
    UPDATE lineitem
    JOIN part ON part.partkey = lineitem.partkey
    SET extendedprice = (quantity * retailprice) * (1 - discount) * (1 + tax)
    WHERE lineitem.orderkey = orderKey;
    
    -- 更新订单总价
    UPDATE orders
    SET totalprice = (
      SELECT SUM(extendedprice)
      FROM lineitem
      WHERE lineitem.orderkey = orderKey
    )
    WHERE orders.orderkey = orderKey;
END
DROP PROCEDURE proc3;
CALL proc3(8);

-- number 4
CREATE PROCEDURE proc4(IN inputKey INT)
BEGIN
    DECLARE orderKey INT;
    
    -- 获取订单键
    SELECT orderkey INTO orderKey
    FROM orders
    WHERE custkey = inputKey
    LIMIT 1;
    
    -- 更新扩展价格
    UPDATE lineitem
    JOIN part ON part.partkey = lineitem.partkey
    SET extendedprice = (quantity * retailprice) * (1 - discount) * (1 + tax)
    WHERE lineitem.orderkey = orderKey;
    
    -- 更新订单总价
    UPDATE orders
    SET totalprice = (
      SELECT SUM(extendedprice)
      FROM lineitem
      WHERE lineitem.orderkey = orderKey
    )
    WHERE orders.orderkey = orderKey;
    
    -- 返回更新后的总价
    SELECT totalprice
    FROM orders 
    WHERE custkey = inputKey;
END;


CALL proc4(8);

-- number 5
DROP PROCEDURE proc4;

-- number 6
CREATE PROCEDURE proc5(IN InputYear INT)
BEGIN
    DECLARE done int DEFAULT 1;
    DECLARE orderKEY INT;
    DECLARE total_Price DECIMAL(20,2);
    
    DECLARE find_cursor CURSOR FOR 
      SELECT orders.orderkey, SUM(extendedprice * (1 - discount) * (1 + tax))
      FROM lineitem, orders
      WHERE lineitem.orderkey = orders.orderkey AND YEAR(orderdate) = InputYear
      GROUP BY orders.orderkey;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 0;
    
    OPEN find_cursor;
    
    loopbegin: WHILE done DO
      FETCH find_cursor INTO orderKEY, total_Price;
      IF done = 0 THEN
        LEAVE loopbegin;
      END IF;
      UPDATE orders SET totalprice = total_Price WHERE orderkey = orderKEY;
    END WHILE loopbegin;
  
    CLOSE find_cursor; 
      
END;


DROP PROCEDURE proc5;
CALL proc5(2023);

SELECT orders.orderkey, SUM(extendedprice * (1 - discount) * (1 + tax)) totalprice
FROM lineitem, orders
WHERE lineitem.orderkey = orders.orderkey AND YEAR(orderdate) = 2023
GROUP BY orders.orderkey;


-- number 7
CREATE PROCEDURE proc6(IN yearInput INT, IN Th INT)
BEGIN
    DECLARE done int DEFAULT 1;
    DECLARE customerID INT;
    DECLARE total_Amount DECIMAL(20,2);
    
    DECLARE find_cursor CURSOR FOR 
      SELECT custkey
      FROM lineitem, orders
      WHERE lineitem.orderkey = orders.orderkey AND YEAR(orderdate) = yearInput 
      GROUP BY custkey
      HAVING SUM(extendedprice * (1 - discount) * (1 + tax)) > Th;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 0;
    
    OPEN find_cursor;    
    
    loopbegin: WHILE done DO
      FETCH find_cursor INTO customerID;
      IF done = 0 THEN
        LEAVE loopbegin;
      END IF;
      UPDATE customer SET comment = 'SVIP' WHERE custkey = customerID;
    END WHILE loopbegin;
    
    CLOSE find_cursor; 
    
END;

DROP PROCEDURE proc6;
CALL proc6(2023, 10000);
