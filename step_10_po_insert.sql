-- Update Requesition header status to approved & Purchase Order insert

exec pms.usp_approve_requisition(1);
exec pms.usp_approve_requisition(2);
exec pms.usp_approve_requisition(3);
exec pms.usp_approve_requisition(4);
exec pms.usp_approve_requisition(5);
exec pms.usp_approve_requisition(6);
exec pms.usp_approve_requisition(7);
exec pms.usp_approve_requisition(8);
exec pms.usp_approve_requisition(9);

-- Purchase Order Line Insert
exec pms.usp_po_line_data (1, 1);

exec pms.usp_po_line_data (1, 2);

exec pms.usp_po_line_data (2, 3);

exec pms.usp_po_line_data (3, 4);
 
exec pms.usp_po_line_data (4, 5);

exec pms.usp_po_line_data (4, 6);

exec pms.usp_po_line_data (5, 7);

exec pms.usp_po_line_data (6, 8);

exec pms.usp_po_line_data (6, 9);

exec pms.usp_po_line_data (7, 10);

exec pms.usp_po_line_data (7, 11);

exec pms.usp_po_line_data (8, 12);

exec pms.usp_po_line_data (9, 13);

exec pms.usp_po_line_data (10, 14);

exec pms.usp_po_line_data (11, 15);

-- Update Purchase Order status to completed
exec pms.usp_po_header_status_update(1,'completed')
exec pms.usp_po_header_status_update(2,'completed')
exec pms.usp_po_header_status_update(3,'completed')
exec pms.usp_po_header_status_update(4,'completed')
exec pms.usp_po_header_status_update(5,'completed')
exec pms.usp_po_header_status_update(6,'completed')
exec pms.usp_po_header_status_update(7,'completed')
exec pms.usp_po_header_status_update(8,'completed')
exec pms.usp_po_header_status_update(9,'completed')
exec pms.usp_po_header_status_update(10,'completed')
exec pms.usp_po_header_status_update(11,'completed')


