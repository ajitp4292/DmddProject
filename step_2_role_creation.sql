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

GRANT  INSERT, SELECT, UPDATE, DELETE  ON ADMIN.requisition_header TO REQUESTOR;
GRANT  INSERT, SELECT, UPDATE, DELETE  ON ADMIN.REQUISITION_HEADER TO REQUESTOR;	
GRANT  SELECT ON ADMIN.item_vendor TO REQUESTOR;
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.requisition_header TO "PROCUREMENT_ANALYST";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.requisition_line TO "PROCUREMENT_ANALYST";
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.purchase_order_header TO "PROCUREMENT_ANALYST";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.purchase_order_line TO "PROCUREMENT_ANALYST";
GRANT  SELECT ON ADMIN.item_vendor TO "PROCUREMENT_ANALYST";
GRANT  SELECT ON ADMIN.item_vendor TO VENDOR;
GRANT  SELECT ON ADMIN.purchase_order_line TO VENDOR;
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.invoice TO VENDOR;	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.item_vendor TO VENDOR;	
GRANT  SELECT ON ADMIN.item TO Vendor;
GRANT  SELECT ON ADMIN.invoice TO Accountant;
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.voucher TO ACCOUNTANT;	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.journal_header TO ACCOUNTANT;	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.journal_line TO ACCOUNTANT;	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.account TO ACCOUNTANT;	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.journal_header TO "FINANCE_OFFICER";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.journal_line TO "FINANCE_OFFICER";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.account TO "FINANCE_OFFICER";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.ledger TO "FINANCE_OFFICER";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.user_table TO "USER_ADMIN";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.address TO "USER_ADMIN";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.contact TO "USER_ADMIN";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.item TO "INVENTORY_ADMIN";	
GRANT  INSERT, SELECT,UPDATE, DELETE  ON ADMIN.vendor TO "INVENTORY_ADMIN";	


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

