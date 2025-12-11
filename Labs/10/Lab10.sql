-- Q1.
CREATE TABLE bank_accounts (
    account_no    VARCHAR2(10) PRIMARY KEY,
    holder_name   VARCHAR2(50),
    balance       NUMBER(12,2)
);

INSERT INTO bank_accounts VALUES ('A', 'Ali',      20000);
INSERT INTO bank_accounts VALUES ('B', 'Babar',    15000);
INSERT INTO bank_accounts VALUES ('C', 'Ahmed',    30000);
COMMIT;

SELECT 'Before Transaction' AS stage, account_no, holder_name, balance FROM bank_accounts ORDER BY account_no;

BEGIN
    UPDATE bank_accounts SET balance = balance - 5000 WHERE account_no = 'A';
    UPDATE bank_accounts SET balance = balance + 5000 WHERE account_no = 'B';
    
    UPDATE bank_accounts SET balance = balance + 99999 WHERE account_no = 'C';  -- wrong account
    
    DBMS_OUTPUT.PUT_LINE('Changes made (not committed yet)');
END;
/

SELECT 'After Updates (before rollback)' AS stage, account_no, balance FROM bank_accounts ORDER BY account_no;

ROLLBACK;

SELECT 'After ROLLBACK → Original values restored' AS stage, account_no, holder_name, balance 
FROM bank_accounts ORDER BY account_no;



-- Q2.
CREATE TABLE inventory (
    item_id     NUMBER PRIMARY KEY,
    item_name   VARCHAR2(50),
    quantity    NUMBER
);

INSERT INTO inventory VALUES (1, 'Laptop',  50);
INSERT INTO inventory VALUES (2, 'Mouse',   100);
INSERT INTO inventory VALUES (3, 'Keyboard',80);
INSERT INTO inventory VALUES (4, 'Monitor', 30);
COMMIT;

SELECT * FROM inventory ORDER BY item_id;

BEGIN
UPDATE inventory SET quantity = quantity - 10 WHERE item_id = 1;
SAVEPOINT sp1;

UPDATE inventory SET quantity = quantity - 20 WHERE item_id = 2;
SAVEPOINT sp2;

UPDATE inventory SET quantity = quantity - 5  WHERE item_id = 3;

ROLLBACK TO sp1;

COMMIT; 

SELECT 'After Transaction (only item 1 reduced)' AS result, * FROM inventory ORDER BY item_id;



-- Q3.
CREATE TABLE fees (
    student_id    NUMBER PRIMARY KEY,
    name          VARCHAR2(50),
    amount_paid   NUMBER(10,2),
    total_fee     NUMBER(10,2)
);

INSERT INTO fees VALUES (101, 'Hassan',  20000, 50000);
INSERT INTO fees VALUES (102, 'Fatima',  15000, 50000);
INSERT INTO fees VALUES (103, 'Omar',    30000, 50000);
COMMIT;

SELECT * FROM fees;

UPDATE fees SET amount_paid = amount_paid + 10000 WHERE student_id = 101;
SAVEPOINT halfway;

UPDATE fees SET amount_paid = amount_paid + 15000 WHERE student_id = 102;

ROLLBACK TO halfway;

COMMIT; 

SELECT 'Final state after partial rollback' AS info, * FROM fees;



-- Q4.
CREATE TABLE products (
    product_id    NUMBER PRIMARY KEY,
    product_name  VARCHAR2(50),
    stock         NUMBER
);

CREATE TABLE orders (
    order_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id    NUMBER,
    quantity      NUMBER,
    order_date    DATE DEFAULT SYSDATE,
    CONSTRAINT fk_prod FOREIGN KEY(product_id) REFERENCES products(product_id)
);

INSERT INTO products VALUES (1, 'USB Drive', 200);
INSERT INTO products VALUES (2, 'Webcam', 50);
COMMIT;

BEGIN
    UPDATE products SET stock = stock - 30 WHERE product_id = 1;
    INSERT INTO orders (product_id, quantity) VALUES (1, 30);
    DELETE FROM products WHERE product_id = 2;  -- mistake!
END;
/

ROLLBACK;

SELECT 'After ROLLBACK – everything back' AS stage, p.*, (SELECT COUNT(*) FROM orders) AS order_count 
FROM products p;

BEGIN
    UPDATE products SET stock = stock - 25 WHERE product_id = 1;
    INSERT INTO orders (product_id, quantity) VALUES (1, 25);
END;
/

COMMIT;

SELECT 'Final correct state' AS info FROM products;
SELECT 'Orders table' AS info, order_id, product_id, quantity FROM orders;



-- Q5. 
CREATE TABLE employees (
    emp_id    NUMBER PRIMARY KEY,
    emp_name  VARCHAR2(50),
    salary    NUMBER(10,2)
);

INSERT INTO employees VALUES (1, 'Sara',   80000);
INSERT INTO employees VALUES (2, 'Khan',   75000);
INSERT INTO employees VALUES (3, 'Ayesha', 90000);
INSERT INTO employees VALUES (4, 'Zain',   70000);
INSERT INTO employees VALUES (5, 'Noor',   85000);
COMMIT;

SELECT * FROM employees ORDER BY emp_id;

UPDATE employees SET salary = salary + 10000 WHERE emp_id = 1;
SAVEPOINT A;

UPDATE employees SET salary = salary + 12000 WHERE emp_id = 2;
SAVEPOINT B;

UPDATE employees SET salary = salary + 15000 WHERE emp_id = 3;

ROLLBACK TO SAVEPOINT A;

COMMIT;

SELECT 'Final salaries (only emp 1 got raise)' AS result, * FROM employees ORDER BY emp_id;
