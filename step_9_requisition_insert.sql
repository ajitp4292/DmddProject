/* Requisitions create & Requisition line create */

DECLARE
  req_creator_id NUMBER := 2;
  req_approver_id NUMBER := 1;
  reqi_desc VARCHAR2(100) := 'Purchase nongoods chair(5 qty) and Desk Furniture(5 qty)(CASH) for office use';
  item_vendor_id VARCHAR2(100) := '14,15';
  quantity VARCHAR2(100) := '5,5';
  
BEGIN
  PMS.usp_create_requisition(req_creator_id, reqi_desc, item_vendor_id, quantity, req_approver_id);
END;

DECLARE
  req_creator_id NUMBER := 2;
  req_approver_id NUMBER := 1;
  reqi_desc VARCHAR2(100) := 'Purchase nongoods Xerox Machine(1 qty)(Bank) for 5000';
  item_vendor_id VARCHAR2(100) := '2';
  quantity VARCHAR2(100) := '1';
  
BEGIN
  PMS.usp_create_requisition(req_creator_id, reqi_desc, item_vendor_id, quantity, req_approver_id);
END;

DECLARE
  req_creator_id NUMBER := 2;
  req_approver_id NUMBER := 1;
  reqi_desc VARCHAR2(100) := 'Purchase goods Macbook Air (2 qty) Laptop (CASH) for 2000';
  item_vendor_id VARCHAR2(100) := '4';
  quantity VARCHAR2(100) := '2';
  
BEGIN
  PMS.usp_create_requisition(req_creator_id, reqi_desc, item_vendor_id, quantity, req_approver_id);
END;

DECLARE
  req_creator_id NUMBER := 2;
  req_approver_id NUMBER := 1;
  reqi_desc VARCHAR2(100) := 'Purchase goods Apple Ipad Pro (10 qty) Asus ThinkPad (10 qty)(for Credit) for 10,000';
  item_vendor_id VARCHAR2(100) := '6,9';
  quantity VARCHAR2(100) := '10,10';
  
BEGIN
  PMS.usp_create_requisition(req_creator_id, reqi_desc, item_vendor_id, quantity, req_approver_id);
END;


DECLARE
  req_creator_id NUMBER := 2;
  req_approver_id NUMBER := 1;
  reqi_desc VARCHAR2(100) := 'Purchase goods TV(1),Ipad Pro(4ty),Macbook Air (10 qty)(CASH) for 15000';
  item_vendor_id VARCHAR2(100) := '19,6,4';
  quantity VARCHAR2(100) := '1,4,10';
  
BEGIN
  PMS.usp_create_requisition(req_creator_id, reqi_desc, item_vendor_id, quantity, req_approver_id);
END;

DECLARE
  req_creator_id NUMBER := 2;
  req_approver_id NUMBER := 1;
  reqi_desc VARCHAR2(100) := 'Purchase goods HP Laptop(2 qty) and Printer(1 qty)(CASH) of 2000';
  item_vendor_id VARCHAR2(100) := '12,13';
  quantity VARCHAR2(100) := '2,1';
  
BEGIN
  PMS.usp_create_requisition(req_creator_id, reqi_desc, item_vendor_id, quantity, req_approver_id);
END;

DECLARE
  req_creator_id NUMBER := 2;
  req_approver_id NUMBER := 1;
  reqi_desc VARCHAR2(100) := 'Purchase goods(1500 - Bank Payment) ASUS notebook (3 qty) and thinkpad(3 qty)';
  item_vendor_id VARCHAR2(100) := '8,20';
  quantity VARCHAR2(100) := '3,3';
  
BEGIN
 PMS.usp_create_requisition(req_creator_id, reqi_desc, item_vendor_id, quantity, req_approver_id);
END;

DECLARE
  req_creator_id NUMBER := 2;
  req_approver_id NUMBER := 1;
  reqi_desc VARCHAR2(100) := 'Purchase nongoods (2000 - Bank Payment ) Locker (4 qty)';
  item_vendor_id VARCHAR2(100) := '16';
  quantity VARCHAR2(100) := '4';
  
BEGIN
  PMS.usp_create_requisition(req_creator_id, reqi_desc, item_vendor_id, quantity, req_approver_id);
END;

DECLARE
  req_creator_id NUMBER := 2;
  req_approver_id NUMBER := 1;
  reqi_desc VARCHAR2(100) := 'Purchase goods (3200 $) Macbook Pro on Credit(4 qty)';
  item_vendor_id VARCHAR2(100) := '5';
  quantity VARCHAR2(100) := '4';
  
BEGIN
  PMS.usp_create_requisition(req_creator_id, reqi_desc, item_vendor_id, quantity, req_approver_id);
END;