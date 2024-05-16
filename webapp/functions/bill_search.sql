--
-- Function for getting the bill for a specific guest
--

DROP FUNCTION IF EXISTS bill_search;

CREATE FUNCTION bill_search(guest_id int)
RETURNS TABLE(bill_id int, total_cost numeric) AS $$
  SELECT 
    b.BillID,
    (b.BillTotal + COALESCE(SUM(bc.Charge), 0) - COALESCE(SUM(bd.Discount), 0)) AS total_cost
  FROM 
    Bill b
  LEFT JOIN 
    Bill_Charge bc ON b.BillID = bc.BillID
  LEFT JOIN 
    Bill_Discount bd ON b.BillID = bd.BillID
  WHERE 
    b.GuestID = guest_id
  GROUP BY 
    b.BillID, b.BillTotal
$$ LANGUAGE SQL STABLE STRICT;

ALTER FUNCTION bill_search(guest_id int) OWNER TO engeo;