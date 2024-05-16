--
-- Queries the database to get all the reviews for a hotel.
--

DROP FUNCTION IF EXISTS show_orders(Requested_GuestID integer);
CREATE FUNCTION show_orders(Requested_GuestID integer)
RETURNS TABLE (OrderID integer, OrderedItem varchar(50), TotalPrice integer) AS $func$

    SELECT Orders.OrderID, Orders_OrderedItem.OrderedItem, Orders_OrderedItem.ItemPrice
    FROM Orders
    JOIN Orders_OrderedItem ON Orders.OrderID = Orders_OrderedItem.OrderID
    WHERE Orders.GuestID = Requested_GuestID

$func$ LANGUAGE SQL STABLE STRICT; 

ALTER FUNCTION show_orders(Requested_GuestID integer) OWNER TO engeo;