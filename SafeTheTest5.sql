SHOW GRANTS;
SHOW GRANTS FOR CURRENT_USER;

# number 1.1
CREATE USER 'David'@'localhost' IDENTIFIED BY '123456';
CREATE USER 'Tom'@'localhost' IDENTIFIED BY '123456';
CREATE USER 'Jerry'@'localhost' IDENTIFIED BY '123456';

GRANT CREATE USER, CREATE ROLE ON *.* TO 'David'@'localhost';
GRANT CREATE USER, CREATE ROLE ON *.* TO 'Tom'@'localhost';
GRANT CREATE USER, CREATE ROLE ON *.* TO 'Jerry'@'localhost';
FLUSH PRIVILEGES;

SHOW GRANTS FOR 'David'@'localhost';
SHOW GRANTS FOR 'Tom'@'localhost';
SHOW GRANTS FOR 'employ';

# number 1.2
CREATE USER 'Marry@localhost' IDENTIFIED BY 'Marry';
CREATE USER 'Jack@localhost' IDENTIFIED BY 'Jack';
CREATE USER 'Mike@localhost' IDENTIFIED BY 'Mike';

# number 2.1
CREATE ROLE 'Buy';
GRANT SELECT ON test.part TO 'Buy';
GRANT SELECT ON test.supplier TO 'Buy';
GRANT SELECT ON test.partsupp TO 'Buy';
CREATE ROLE 'Sell';
GRANT SELECT ON test.orders TO 'Sell';
GRANT SELECT ON test.lineitem TO 'Sell';
CREATE ROLE 'Custom';
GRANT SELECT ON test.customer TO 'Custom';
GRANT SELECT ON test.nation TO 'Custom';
GRANT SELECT ON test.region TO 'Custom';

SHOW GRANTS FOR 'Buy';
SHOW GRANTS FOR 'Sell';
SHOW GRANTS FOR 'Custom';

# number 2.2
CREATE ROLE 'BuyEmployee';
GRANT 'Buy' TO 'BuyEmployee';
GRANT INSERT ON test.part TO 'BuyEmployee';
GRANT INSERT ON test.supplier TO 'BuyEmployee';
GRANT INSERT ON test.partsupp TO 'BuyEmployee';
CREATE ROLE 'SellEmployee';
GRANT 'Sell' TO 'SellEmployee';
GRANT INSERT ON TABLE orders TO 'SellEmployee';
GRANT INSERT ON test.lineitem TO 'SellEmployee';
CREATE ROLE 'CustomEmployee';
GRANT 'Custom' TO 'CustomEmployee';
GRANT INSERT ON test.customer TO 'CustomEmployee';
GRANT INSERT ON test.nation TO 'CustomEmployee';
GRANT INSERT ON test.region TO 'CustomEmployee';

SHOW GRANTS FOR 'BuyEmployee';
SHOW GRANTS FOR 'SellEmployee';
SHOW GRANTS FOR 'CustomEmployee';
# number 2.3
CREATE ROLE 'BuyEmploy';
GRANT ALL PRIVILEGES ON test.part TO 'BuyEmploy';
GRANT ALL PRIVILEGES ON test.supplier TO 'BuyEmploy';
GRANT ALL PRIVILEGES ON test.partsupp TO 'BuyEmploy';
GRANT GRANT OPTION ON test.* TO 'BuyEmploy';
CREATE ROLE 'SellEmploy';
GRANT ALL PRIVILEGES ON TABLE orders TO 'SellEmploy';
GRANT ALL PRIVILEGES ON lineitem TO 'SellEmploy';
GRANT GRANT OPTION ON test.* TO 'SellEmploy';
CREATE ROLE 'CustomEmploy';
GRANT ALL PRIVILEGES ON customer TO 'CustomEmploy';
GRANT ALL PRIVILEGES ON nation TO 'CustomEmploy';
GRANT ALL PRIVILEGES ON region TO 'CustomEmploy';
GRANT GRANT OPTION ON test.* TO 'CustomEmploy';

SHOW GRANTS FOR 'BuyEmploy';
SHOW GRANTS FOR 'SellEmploy';
SHOW GRANTS FOR 'CustomEmploy';

# number 3.1
GRANT 'BuyEmploy' TO 'David'@'localhost';
GRANT 'SellEmploy' TO 'Tom'@'localhost';
GRANT 'CustomEmploy' TO 'Jerry'@'localhost';
SHOW GRANTS FOR 'David'@'localhost';
SHOW GRANTS FOR 'Tom'@'localhost';
SHOW GRANTS FOR 'Jerry'@'localhost';

# number 3.2
GRANT 'BuyEmployee' TO 'Marry@localhost';
GRANT 'SellEmployee' TO 'Jack@localhost';
GRANT 'CustomEmployee' TO 'Mike@localhost';
SHOW GRANTS FOR 'Mike@localhost';
# number 4.1
REVOKE SELECT ON customer FROM CustomEmploy;
# number 4.2
REVOKE 'CustomEmployee' FROM 'Mike@localhost';
# number 5.1
SET DEFAULT ROLE 'BuyEmploy' TO 'David'@'localhost';
SHOW GRANTS FOR 'David'@'localhost';
FLUSH PRIVILEGES;
# number 5.2
# use cmd to test.