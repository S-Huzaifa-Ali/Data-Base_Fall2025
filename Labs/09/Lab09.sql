
-- 1.
CREATE OR REPLACE TRIGGER trg_students_uppercase_name
BEFORE INSERT ON STUDENTS
FOR EACH ROW
BEGIN
    :NEW.student_name := UPPER(:NEW.student_name);
END;
/

-- 2.
CREATE OR REPLACE TRIGGER trg_no_delete_weekend
BEFORE DELETE ON EMPLOYEES
BEGIN
    IF TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=AMERICAN') IN ('SAT', 'SUN') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Deletions from EMPLOYEES are not allowed on weekends!');
    END IF;
END;
/

-- 3.
CREATE TABLE LOG_SALARY_AUDIT (
    log_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id  NUMBER,
    old_salary   NUMBER,
    new_salary   NUMBER,
    changed_by   VARCHAR2(100) := USER,
    change_date  DATE         := SYSDATE
);

CREATE OR REPLACE TRIGGER trg_log_salary_update
BEFORE UPDATE OF salary ON EMPLOYEES
FOR EACH ROW
BEGIN
    INSERT INTO LOG_SALARY_AUDIT(employee_id, old_salary, new_salary)
    VALUES (:OLD.employee_id, :OLD.salary, :NEW.salary);
END;
/

-- 4.
CREATE OR REPLACE TRIGGER trg_products_no_negative_price
BEFORE INSERT OR UPDATE OF price ON PRODUCTS
FOR EACH ROW
BEGIN
    IF :NEW.price < 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Product price cannot be negative!');
    END IF;
END;
/

-- 5. 
CREATE OR REPLACE TRIGGER trg_courses_audit_insert
BEFORE INSERT ON COURSES
FOR EACH ROW
BEGIN
    :NEW.created_by  := USER;
    :NEW.created_date := SYSDATE;
END;
/

-- 6. 
CREATE OR REPLACE TRIGGER trg_emp_default_dept
BEFORE INSERT ON EMP
FOR EACH ROW
WHEN (NEW.department_id IS NULL)
BEGIN
    :NEW.department_id := 10;  -- Default department (e.g., Administration)
END;
/

-- 7.
CREATE TABLE SALES_SUMMARY (
    process_date   DATE,
    total_amount   NUMBER(12,2),
    rows_processed NUMBER
);

CREATE OR REPLACE TRIGGER trg_sales_compound
FOR INSERT ON SALES
COMPOUND TRIGGER

    -- Global variables
    g_total_amount NUMBER := 0;
    g_row_count     NUMBER := 0;

    -- Executed once before the statement
    BEFORE STATEMENT IS
    BEGIN
        g_total_amount := 0;
        g_row_count    := 0;
        DBMS_OUTPUT.PUT_LINE('Bulk insert started...');
    END BEFORE STATEMENT;

    -- Executed for each row
    AFTER EACH ROW IS
    BEGIN
        g_total_amount := g_total_amount + (:NEW.quantity * :NEW.unit_price);
        g_row_count    := g_row_count + 1;
    END AFTER EACH ROW;

    -- Executed once after the statement
    AFTER STATEMENT IS
    BEGIN
        INSERT INTO SALES_SUMMARY(process_date, total_amount, rows_processed)
        VALUES (SYSDATE, g_total_amount, g_row_count);

        DBMS_OUTPUT.PUT_LINE('Inserted ' || g_row_count || ' rows. Total = ' || g_total_amount);
    END AFTER STATEMENT;

END trg_sales_compound;
/

-- 8.
CREATE TABLE SCHEMA_DDL_LOG (
    log_id       NUMBER GENERATED ALWAYS AS IDENTITY,
    ddl_date     DATE         := SYSDATE,
    ddl_type     VARCHAR2(30),
    object_type  VARCHAR2(30),
    object_name  VARCHAR2(128),
    owner        VARCHAR2(128) := USER,
    os_user      VARCHAR2(100) := SYS_CONTEXT('USERENV','OS_USER'),
    host         VARCHAR2(100) := SYS_CONTEXT('USERENV','HOST')
);

CREATE OR REPLACE TRIGGER trg_ddl_audit
AFTER DDL ON SCHEMA
BEGIN
    IF ORA_DICT_OBJ_TYPE IN ('TABLE','VIEW','PROCEDURE','FUNCTION','PACKAGE','TRIGGER','INDEX') THEN
        INSERT INTO SCHEMA_DDL_LOG(ddl_type, object_type, object_name)
        VALUES (ORA_SYSEVENT, ORA_DICT_OBJ_TYPE, ORA_DICT_OBJ_NAME);
    END IF;
END;
/

-- 9.
CREATE OR REPLACE TRIGGER trg_no_update_shipped_orders
BEFORE UPDATE ON ORDERS
FOR EACH ROW
WHEN (OLD.order_status = 'SHIPPED')
BEGIN
    RAISE_APPLICATION_ERROR(-20003, 'Cannot modify an order that has already been SHIPPED.');
END;
/

-- 10. 
CREATE TABLE LOGIN_AUDIT (
    audit_id     NUMBER GENERATED ALWAYS AS IDENTITY,
    username     VARCHAR2(128),
    login_time   DATE         := SYSDATE,
    os_user      VARCHAR2(100),
    host         VARCHAR2(100),
    ip_address   VARCHAR2(50)
);

CREATE OR REPLACE TRIGGER trg_logon_audit
AFTER LOGON ON SCHEMA
BEGIN
    INSERT INTO LOGIN_AUDIT(username, os_user, host, ip_address)
    VALUES (
        USER,
        SYS_CONTEXT('USERENV','OS_USER'),
        SYS_CONTEXT('USERENV','HOST'),
        SYS_CONTEXT('USERENV','IP_ADDRESS')
    );
END;

/
