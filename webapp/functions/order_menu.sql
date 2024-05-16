--
-- Queries the database to get all the reviews for a hotel.
--

DROP FUNCTION IF EXISTS order_menu();
CREATE FUNCTION order_menu()
RETURNS TABLE (item varchar(50), price integer) AS $func$

    SELECT DISTINCT OrderedItem, ItemPrice
    FROM Orders_OrderedItem

$func$ LANGUAGE SQL STABLE STRICT; 

ALTER FUNCTION view_reviews(Review_HotelName varchar(100)) OWNER TO engeo;