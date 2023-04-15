
set serveroutput on
declare
    v_view_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start view cleanup');
   for i in (select view_name from all_views
where owner='PMS' )
   loop
   dbms_output.put_line('....Drop VIEW PMS.'||i.view_name);
   begin
       select 'Y' into v_view_exists
       from all_views
       where view_name=i.view_name ;

       v_sql := 'drop VIEW PMS.'||i.view_name;
       execute immediate v_sql;
       dbms_output.put_line('........VIEW '||i.view_name||' dropped successfully');
       
   exception
       when no_data_found then
           dbms_output.put_line('........VIEW already dropped');
   end;
   end loop;
   dbms_output.put_line('VIEW cleanup successfully completed');
exception
   when others then
      dbms_output.put_line('Failed to execute code:'||sqlerrm);
end;
/

set serveroutput on
declare
    v_table_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start schema cleanup');
   for i in (select table_name from user_tables
   )
   loop
   dbms_output.put_line('....Drop table '||i.table_name);
   begin
       select 'Y' into v_table_exists
       from USER_TABLES
       where TABLE_NAME=i.table_name;

       v_sql := 'drop table '||i.table_name ||' cascade constraints';
       execute immediate v_sql;
       dbms_output.put_line('........Table '||i.table_name||' dropped successfully');
       
   exception
       when no_data_found then
           dbms_output.put_line('........Table already dropped');
   end;
   end loop;
   dbms_output.put_line('Schema cleanup successfully completed');
exception
   when others then
      dbms_output.put_line('Failed to execute code:'||sqlerrm);
end;
/

BEGIN
  DECLARE
    user_count INTEGER;
  BEGIN
    SELECT COUNT(*) INTO user_count FROM all_users WHERE username = 'PMS';
    IF user_count > 0 THEN
      EXECUTE IMMEDIATE 'DROP USER PMS CASCADE';
    END IF;
  END;
END;
/

create user PMS identified by Admin#1234567890;
ALTER USER PMS QUOTA 100M ON USERS;
/*User table*/
CREATE TABLE PMS.USER_TABLE 
(
  USER_ID NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 NOT NULL 
, USERNAME VARCHAR2(30 BYTE) NOT NULL 
, ROLE VARCHAR2(20 BYTE) NOT NULL 
, FIRST_NAME VARCHAR2(20 BYTE) NOT NULL 
, LAST_NAME VARCHAR2(20 BYTE) NOT NULL 
, CONSTRAINT TABLE1_PK PRIMARY KEY 
  (
    USER_ID 
  )
  USING INDEX 
  (
      CREATE UNIQUE INDEX PMS.TABLE1_PK ON PMS.USER_TABLE (USER_ID ASC) 
      LOGGING 
      TABLESPACE DATA 
      PCTFREE 10 
      INITRANS 20 
      STORAGE 
      ( 
        BUFFER_POOL DEFAULT 
      ) 
      NOPARALLEL 
  )
  ENABLE 
);

alter table PMS.USER_TABLE
modify USER_ID generated always as identity restart start with 1;

/*address table.*/ 
CREATE TABLE PMS.ADDRESS 
(
  ADD_ID NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 CACHE 20 NOT NULL 
, STREET VARCHAR2(60 BYTE) NOT NULL 
, STATE VARCHAR2(20 BYTE) NOT NULL 
, ZIPCODE NUMBER NOT NULL 
, STATUS VARCHAR2(20 BYTE) NOT NULL 
, ACTOR_ID NUMBER NOT NULL 
, CONSTRAINT ADDRESS_PK PRIMARY KEY 
  (
    ADD_ID 
  )
  USING INDEX 
  (
      CREATE UNIQUE INDEX PMS.ADDRESS_PK ON PMS.ADDRESS (ADD_ID ASC) 
      LOGGING 
      TABLESPACE DATA 
      PCTFREE 10 
      INITRANS 20 
      STORAGE 
      ( 
        BUFFER_POOL DEFAULT 
      ) 
      NOPARALLEL 
  )
  ENABLE 
);

ALTER TABLE PMS.ADDRESS
ADD CONSTRAINT ADDRESS_FK1 FOREIGN KEY
(
  ACTOR_ID 
)
REFERENCES PMS.USER_TABLE
(
  USER_ID 
)
ENABLE;

alter table PMS.ADDRESS
modify ADD_ID generated always as identity restart start with 1;

/*Requisition header table.*/
CREATE TABLE PMS.REQUISITION_HEADER 
(
  REQ_ID NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 NOT NULL 
, REQ_APPROVER_ID NUMBER NOT NULL 
, REQ_CREATOR_ID NUMBER NOT NULL 
, REQ_STATUS VARCHAR2(20) NOT NULL 
, REQ_DESC VARCHAR2(200) NOT NULL 
, APPROVAL_DATE DATE NOT NULL 
, BUDGET_CHECK VARCHAR2(20) NOT NULL 
, REQ_CREATED DATE NOT NULL  
, CONSTRAINT REQ_HDR_PK PRIMARY KEY 
  (
    REQ_ID 
  )
  ENABLE 
);

ALTER TABLE PMS.REQUISITION_HEADER
ADD CONSTRAINT REQ_HDR_FK2 FOREIGN KEY
(
  REQ_APPROVER_ID 
)
REFERENCES PMS.USER_TABLE
(
  USER_ID 
)
ENABLE;

ALTER TABLE PMS.REQUISITION_HEADER
ADD CONSTRAINT REQ_HDR_FK3 FOREIGN KEY
(
  REQ_CREATOR_ID 
)
REFERENCES PMS.USER_TABLE
(
  USER_ID 
)
ENABLE;

alter table PMS.REQUISITION_HEADER
modify REQ_ID generated always as identity restart start with 1;

/*Requisition Line Table.*/
CREATE TABLE PMS.REQUISITION_LINE 
(
  REQ_LINE_NO NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 NOT NULL 
, REQ_ID NUMBER NOT NULL 
, ITEM_VENDOR_ID NUMBER NOT NULL 
, QUANTITY NUMBER NOT NULL 
, CONSTRAINT REQ_LINE_PK PRIMARY KEY 
  (
    REQ_LINE_NO 
  )
  ENABLE 
);

ALTER TABLE PMS.REQUISITION_LINE
ADD CONSTRAINT REQ_LINE_FK1 FOREIGN KEY
(
  REQ_ID 
)
REFERENCES PMS.REQUISITION_HEADER
(
  REQ_ID 
)
ENABLE;

alter table PMS.REQUISITION_LINE
modify REQ_LINE_NO generated always as identity restart start with 1;

/*Contact table.*/
CREATE TABLE PMS.CONTACT 
(
  CONT_ID NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 NOT NULL 
, PHONE_NO NUMBER NOT NULL 
, EMAIL VARCHAR2(30) NOT NULL 
, STATUS VARCHAR2(20) NOT NULL 
, ACTOR_ID NUMBER NOT NULL 
, CONSTRAINT CONTACT_PK PRIMARY KEY 
  (
    CONT_ID 
  )
  ENABLE 
);

ALTER TABLE PMS.CONTACT
ADD CONSTRAINT CONTACT_FK1 FOREIGN KEY
(
  ACTOR_ID 
)
REFERENCES PMS.USER_TABLE
(
  USER_ID 
)
ENABLE;

alter table PMS.CONTACT
modify CONT_ID generated always as identity restart start with 1;

/* Vendor Table */
CREATE TABLE PMS.VENDOR 
(
  VENDOR_ID NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 NOT NULL 
, VENDOR_NAME VARCHAR2(20) NOT NULL 
, ACC_NUM NUMBER NOT NULL 
, STATUS CHAR NOT NULL 
, PAYMENT_METHOD VARCHAR2(20) NOT NULL 
, USER_ID NUMBER NOT NULL 
, CURRENCY VARCHAR2(20) NOT NULL 
, CONSTRAINT VENDOR_PK PRIMARY KEY 
  (
    VENDOR_ID 
  )
  ENABLE 
);

ALTER TABLE PMS.VENDOR
ADD CONSTRAINT VENDOR_FK1 FOREIGN KEY
(
  USER_ID 
)
REFERENCES PMS.USER_TABLE
(
  USER_ID 
)
ENABLE;

alter table PMS.VENDOR
modify VENDOR_ID generated always as identity restart start with 1;

/* Purchase Order Table */
CREATE TABLE PMS.PURCHASE_ORDER_HEADER 
(
  PO_ID NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 CACHE 20 NOT NULL 
, REQ_ID NUMBER NOT NULL 
, VENDOR_ID NUMBER NOT NULL 
, PO_DATE DATE NOT NULL 
, PO_STATUS VARCHAR2(20 BYTE) NOT NULL 
, PO_TOTAL NUMBER NOT NULL 
, CONSTRAINT PURCHASE_ORDER_HEADER_PK PRIMARY KEY 
  (
    PO_ID 
  )
  USING INDEX 
  (
      CREATE UNIQUE INDEX PMS.PURCHASE_ORDER_HEADER_PK ON PMS.PURCHASE_ORDER_HEADER (PO_ID ASC) 
      LOGGING 
      TABLESPACE DATA 
      PCTFREE 10 
      INITRANS 20 
      STORAGE 
      ( 
        BUFFER_POOL DEFAULT 
      ) 
      NOPARALLEL 
  )
  ENABLE 
);

ALTER TABLE PMS.PURCHASE_ORDER_HEADER
ADD CONSTRAINT PURCHASE_ORDER_HEADER_FK1 FOREIGN KEY
(
  VENDOR_ID 
)
REFERENCES PMS.VENDOR
(
  VENDOR_ID 
)
ENABLE;

ALTER TABLE PMS.PURCHASE_ORDER_HEADER
ADD CONSTRAINT PURCHASE_ORDER_HEADER_FK2 FOREIGN KEY
(
  REQ_ID 
)
REFERENCES PMS.REQUISITION_HEADER
(
  REQ_ID 
)
ENABLE;

alter table PMS.PURCHASE_ORDER_HEADER
modify PO_ID generated always as identity restart start with 1;

/* Purchase Order Line */
CREATE TABLE PMS.PURCHASE_ORDER_LINE 
(
  PO_LINE_NO NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 NOT NULL 
, PO_ID NUMBER NOT NULL 
, REQ_LINE_NO NUMBER NOT NULL 
, CONSTRAINT PURCHASE_ORDER_LINE_PK PRIMARY KEY 
  (
    PO_LINE_NO 
  )
  ENABLE 
);

ALTER TABLE PMS.PURCHASE_ORDER_LINE
ADD CONSTRAINT PURCHASE_ORDER_LINE_FK1 FOREIGN KEY
(
  PO_ID 
)
REFERENCES PMS.PURCHASE_ORDER_HEADER
(
  PO_ID 
)
ENABLE;

ALTER TABLE PMS.PURCHASE_ORDER_LINE
ADD CONSTRAINT PURCHASE_ORDER_LINE_FK2 FOREIGN KEY
(
  REQ_LINE_NO 
)
REFERENCES PMS.REQUISITION_LINE
(
  REQ_LINE_NO 
)
ENABLE;

alter table PMS.PURCHASE_ORDER_LINE
modify PO_LINE_NO generated always as identity restart start with 1;

/* Item Table */
CREATE TABLE PMS.ITEM 
(
  ITEM_ID NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 NOT NULL 
, CATEGORY_NAME VARCHAR2(20) NOT NULL 
, ITEM_NAME VARCHAR2(20) NOT NULL 
, ITEM_DESC VARCHAR2(30) NOT NULL 
, CONSTRAINT ITEM_PK PRIMARY KEY 
  (
    ITEM_ID 
  )
  ENABLE 
);

alter table PMS.ITEM
modify ITEM_ID generated always as identity restart start with 1;

/* Item Vendor Table */
CREATE TABLE PMS.ITEM_VENDOR 
(
  ITEM_VENDOR_ID NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 NOT NULL 
, ITEM_ID NUMBER NOT NULL 
, VENDOR_ID NUMBER NOT NULL 
, PRICE NUMBER NOT NULL 
, MINIMUM_ORDER NUMBER NOT NULL 
, CREATED_DATE DATE NOT NULL 
, UPDATED_DATE DATE NOT NULL 
, CONSTRAINT ITEM_VENDOR_PK PRIMARY KEY 
  (
    ITEM_VENDOR_ID 
  )
  ENABLE 
);

ALTER TABLE PMS.ITEM_VENDOR
ADD CONSTRAINT ITEM_VENDOR_FK1 FOREIGN KEY
(
  ITEM_ID 
)
REFERENCES PMS.ITEM
(
  ITEM_ID 
)
ENABLE;

ALTER TABLE PMS.ITEM_VENDOR
ADD CONSTRAINT ITEM_VENDOR_FK2 FOREIGN KEY
(
  VENDOR_ID 
)
REFERENCES PMS.VENDOR
(
  VENDOR_ID 
)
ENABLE;

alter table PMS.ITEM_VENDOR
modify ITEM_VENDOR_ID generated always as identity restart start with 1;

/* Invoice */
CREATE TABLE PMS.INVOICE 
(
  INVOICE_ID NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 NOT NULL 
, PO_ID NUMBER NOT NULL 
, GROSS_AMT NUMBER NOT NULL 
, CREATED_DATE DATE NOT NULL 
, CONSTRAINT INVOICE_PK PRIMARY KEY 
  (
    INVOICE_ID 
  )
  ENABLE 
);

ALTER TABLE PMS.INVOICE
ADD CONSTRAINT INVOICE_FK1 FOREIGN KEY
(
  PO_ID 
)
REFERENCES PMS.PURCHASE_ORDER_HEADER
(
  PO_ID 
)
ENABLE;

alter table PMS.INVOICE
modify INVOICE_ID generated always as identity restart start with 1;

/* Voucher */
CREATE TABLE PMS.VOUCHER 
(
  VOUCHER_ID NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 NOT NULL 
, INVOICE_ID NUMBER NOT NULL 
, VENDOR_ID NUMBER NOT NULL 
, INVOICE_DATE DATE NOT NULL 
, STATUS VARCHAR2(20) NOT NULL 
, GROSS_AMT NUMBER NOT NULL 
, ACCOUNTING_DATE DATE NOT NULL 
, CONSTRAINT VOUCHER_PK PRIMARY KEY 
  (
    VOUCHER_ID 
  )
  ENABLE 
);

ALTER TABLE PMS.VOUCHER
ADD CONSTRAINT VOUCHER_FK1 FOREIGN KEY
(
  VENDOR_ID 
)
REFERENCES PMS.VENDOR
(
  VENDOR_ID 
)
ENABLE;

ALTER TABLE PMS.VOUCHER
ADD CONSTRAINT VOUCHER_FK2 FOREIGN KEY
(
  INVOICE_ID 
)
REFERENCES PMS.INVOICE
(
  INVOICE_ID 
)
ENABLE;

alter table PMS.VOUCHER
modify VOUCHER_ID generated always as identity restart start with 1;

/* Journal Header */
CREATE TABLE PMS.JOURNAL_HEADER 
(
  JRNL_ID NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 NOT NULL 
, JRNL_DATE DATE NOT NULL 
, FISCAL_YEAR NUMBER NOT NULL 
, ACCOUNTING_PERIOD NUMBER NOT NULL 
, STATUS VARCHAR2(20) 
, CONSTRAINT JOURNAL_HEADER_PK PRIMARY KEY 
  (
    JRNL_ID 
  )
  ENABLE 
);

alter table PMS.JOURNAL_HEADER
modify JRNL_ID generated always as identity restart start with 1;

/* Journal Line */
CREATE TABLE PMS.JOURNAL_LINE 
(
  JRNL_LINE_NO NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 NOT NULL 
, JRNL_ID NUMBER NOT NULL 
, ACCOUNT_ID NUMBER NOT NULL 
, AMOUNT NUMBER NOT NULL 
, DESCRIPTION VARCHAR2(60) NOT NULL 
, TRANSACTION_FLAG VARCHAR2(20) NOT NULL 
, CONSTRAINT JOURNAL_LINE_PK PRIMARY KEY 
  (
    JRNL_LINE_NO 
  )
  ENABLE 
);

ALTER TABLE PMS.JOURNAL_LINE
ADD CONSTRAINT JOURNAL_LINE_FK1 FOREIGN KEY
(
  JRNL_ID 
)
REFERENCES PMS.JOURNAL_HEADER
(
  JRNL_ID 
)
ENABLE;

/* Account Table */
CREATE TABLE PMS.ACCOUNT 
(
  ACCOUNT_ID NUMBER NOT NULL 
, ACCOUNT_NAME VARCHAR2(40) NOT NULL 
, ACCOUNT_TYPE VARCHAR2(20) NOT NULL 
, CONSTRAINT ACCOUNT_PK PRIMARY KEY 
  (
    ACCOUNT_ID 
  )
  ENABLE 
);

ALTER TABLE PMS.JOURNAL_LINE
ADD CONSTRAINT JOURNAL_LINE_FK2 FOREIGN KEY
(
  ACCOUNT_ID 
)
REFERENCES PMS.ACCOUNT
(
  ACCOUNT_ID 
)
ENABLE;

ALTER TABLE PMS.JOURNAL_LINE  
MODIFY (DESCRIPTION VARCHAR2(100 BYTE) );

alter table PMS.JOURNAL_LINE
modify JRNL_LINE_NO generated always as identity restart start with 1;

/* Ledger Table */
CREATE TABLE PMS.LEDGER 
(
  LEDGER_ID NUMBER GENERATED ALWAYS AS IDENTITY INCREMENT BY 1 NOT NULL 
, JRNL_ID NUMBER NOT NULL 
, JRNL_LINE_NO NUMBER NOT NULL 
, ACCOUNT_ID NUMBER NOT NULL 
, ACCOUNTING_DATE DATE NOT NULL 
, TRANSACTION_FLAG varchar(20) NOT NULL 
, AMOUNT NUMBER NOT NULL 
, CONSTRAINT LEDGER_PK PRIMARY KEY 
  (
    LEDGER_ID 
  )
  ENABLE 
);

ALTER TABLE PMS.LEDGER
ADD CONSTRAINT LEDGER_FK1 FOREIGN KEY
(
  JRNL_ID 
)
REFERENCES PMS.JOURNAL_HEADER
(
  JRNL_ID 
)
ENABLE;

ALTER TABLE PMS.LEDGER
ADD CONSTRAINT LEDGER_FK2 FOREIGN KEY
(
  JRNL_LINE_NO 
)
REFERENCES PMS.JOURNAL_LINE
(
  JRNL_LINE_NO 
)
ENABLE;

ALTER TABLE PMS.LEDGER
ADD CONSTRAINT LEDGER_FK3 FOREIGN KEY
(
  ACCOUNT_ID 
)
REFERENCES PMS.ACCOUNT
(
  ACCOUNT_ID 
)
ENABLE;

alter table PMS.LEDGER
modify LEDGER_ID generated always as identity restart start with 1;

--CLEANUP SCRIPT

BEGIN
  FOR r IN (select sid,serial# from v$session where USERNAME in(
'REQUESTOR_USER',
'PROCUREMENT_ANALYST_USER',
'VENDOR_USER',
'ACCOUNTANT_USER',
'FINANCE_OFFICER_USER',
'USER_ADMIN_USER',
'INVENTORY_ADMIN_USER',
'VENDOR_USER_WALMART',
'VENDOR_USER_WAYFAIR',
'VENDOR_USER_PRICERITE',
'VENDOR_USER_BESTBUY',
'VENDOR_USER_STAPLES'
))
  LOOP
      EXECUTE IMMEDIATE 'alter system kill session ''' || r.sid  || ',' 
        || r.serial# || ''' immediate';
  END LOOP;
END;
/
set serveroutput on
declare
    v_user_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start user cleanup');
   for i in (select USERNAME from all_users
WHERE USERNAME in(
'REQUESTOR_USER',
'PROCUREMENT_ANALYST_USER',
'VENDOR_USER',
'ACCOUNTANT_USER',
'FINANCE_OFFICER_USER',
'USER_ADMIN_USER',
'INVENTORY_ADMIN_USER',
'VENDOR_USER_WALMART',
'VENDOR_USER_WAYFAIR',
'VENDOR_USER_PRICERITE',
'VENDOR_USER_BESTBUY',
'VENDOR_USER_STAPLES'
)
   )
   loop
   dbms_output.put_line('....Drop user '||i.USERNAME);
   begin
       select 'Y' into v_user_exists
       from all_users
       where USERNAME= i.USERNAME;

       v_sql := 'drop user '||i.USERNAME;
       execute immediate v_sql;
       dbms_output.put_line('........User '||i.USERNAME||' dropped successfully');
       
   exception
       when no_data_found then
           dbms_output.put_line('........User already dropped');
   end;
   end loop;
   dbms_output.put_line('User cleanup successfully completed');
exception
   when others then
      dbms_output.put_line('Failed to execute code:'||sqlerrm);
end;
/

--Role CLEANUP SCRIPT
set serveroutput on
declare
    v_role_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start role cleanup');
   for i in (select distinct role
from DBA_ROLES
where role in (
'REQUESTOR',
'PROCUREMENT_ANALYST',
'VENDOR',
'ACCOUNTANT',
'FINANCE_OFFICER',
'USER_ADMIN',
'INVENTORY_ADMIN')
   )
   loop
   dbms_output.put_line('....Drop role '||i.role);
   begin
       select 'Y' into v_role_exists
       from DBA_ROLES
       where role= i.role;

       v_sql := 'drop role '||i.role;
       execute immediate v_sql;
       dbms_output.put_line('........Role '||i.role||' dropped successfully');
       
   exception
       when no_data_found then
           dbms_output.put_line('........Role already dropped');
   end;
   end loop;
   dbms_output.put_line('Role cleanup successfully completed');
exception
   when others then
      dbms_output.put_line('Failed to execute code:'||sqlerrm);
end;
/

-- Create Roles

CREATE ROLE REQUESTOR;
CREATE ROLE PROCUREMENT_ANALYST;
CREATE ROLE VENDOR;
CREATE ROLE ACCOUNTANT;
CREATE ROLE FINANCE_OFFICER;
CREATE ROLE USER_ADMIN;
CREATE ROLE INVENTORY_ADMIN;

GRANT  INSERT, SELECT, UPDATE, DELETE  ON PMS.requisition_line TO REQUESTOR;
GRANT  INSERT, SELECT, UPDATE, DELETE  ON PMS.REQUISITION_HEADER TO REQUESTOR;	
GRANT  SELECT ON PMS.item_vendor TO REQUESTOR;
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.requisition_header TO "PROCUREMENT_ANALYST";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.requisition_line TO "PROCUREMENT_ANALYST";
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.purchase_order_header TO "PROCUREMENT_ANALYST";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.purchase_order_line TO "PROCUREMENT_ANALYST";
GRANT  SELECT ON PMS.item_vendor TO "PROCUREMENT_ANALYST";
GRANT  SELECT ON PMS.item_vendor TO VENDOR;
GRANT  SELECT ON PMS.purchase_order_line TO VENDOR;
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.invoice TO VENDOR;	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.item_vendor TO VENDOR;	
GRANT  SELECT ON PMS.item TO Vendor;
GRANT  SELECT ON PMS.invoice TO Accountant;
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.voucher TO ACCOUNTANT;	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.journal_header TO ACCOUNTANT;	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.journal_line TO ACCOUNTANT;	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.account TO ACCOUNTANT;	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.journal_header TO "FINANCE_OFFICER";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.journal_line TO "FINANCE_OFFICER";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.account TO "FINANCE_OFFICER";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.ledger TO "FINANCE_OFFICER";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.user_table TO "USER_ADMIN";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.address TO "USER_ADMIN";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.contact TO "USER_ADMIN";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.item TO "INVENTORY_ADMIN";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON PMS.vendor TO "INVENTORY_ADMIN";	


--Create Users

create user requestor_user IDENTIFIED BY REQpmsspring2023;
grant REQUESTOR to requestor_user;

create user procurement_analyst_user IDENTIFIED BY PROpmsspring2023;
grant PROCUREMENT_ANALYST to procurement_analyst_user;

create user vendor_user IDENTIFIED BY VENpmsspring2023;
grant VENDOR to vendor_user;

create user accountant_user IDENTIFIED BY ACCpmsspring2023;
grant ACCOUNTANT to accountant_user;

create user finance_officer_user IDENTIFIED BY FINpmsspring2023;
grant FINANCE_OFFICER to finance_officer_user;

create user user_admin_user IDENTIFIED BY USRpmsspring2023;
grant USER_ADMIN to user_admin_user;

create user inventory_admin_user IDENTIFIED BY INVpmsspring2023;
grant INVENTORY_ADMIN to inventory_admin_user;

create user vendor_user_Walmart IDENTIFIED BY VENpmsspring2023;
grant VENDOR to vendor_user;

create user vendor_user_Wayfair IDENTIFIED BY VENpmsspring2023;
grant VENDOR to vendor_user;

create user vendor_user_Pricerite IDENTIFIED BY VENpmsspring2023;
grant VENDOR to vendor_user;

create user vendor_user_BestBuy IDENTIFIED BY VENpmsspring2023;
grant VENDOR to vendor_user;

create user vendor_user_Staples IDENTIFIED BY VENpmsspring2023;
grant VENDOR to vendor_user;


Grant CREATE SESSION to  requestor_user;
Grant CREATE SESSION to  procurement_analyst_user;
Grant CREATE SESSION to  vendor_user;
Grant CREATE SESSION to  accountant_user;
Grant CREATE SESSION to  finance_officer_user;
Grant CREATE SESSION to  user_admin_user;
Grant CREATE SESSION to  inventory_admin_user;
Grant CREATE SESSION to  vendor_user_Walmart;
Grant CREATE SESSION to  vendor_user_Wayfair;
Grant CREATE SESSION to  vendor_user_Pricerite;
Grant CREATE SESSION to  vendor_user_BestBuy;
Grant CREATE SESSION to  vendor_user_Staples;
Grant CREATE SESSION to  PMS;




