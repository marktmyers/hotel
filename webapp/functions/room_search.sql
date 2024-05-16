--
-- Write a query to list all the rooms of type double that are currently unoccupied and clean
--

DROP FUNCTION IF EXISTS room_search(HotelID integer, RoomStatus text, TypeName varchar(100));

CREATE FUNCTION room_search(HotelID integer, RoomStatus text, TypeName varchar(100))
RETURNS SETOF room AS $$

  SELECT *
  FROM room
  WHERE HotelID = $1
    AND RoomStatus = $2
    AND TypeName = $3

$$ LANGUAGE SQL STABLE STRICT;

ALTER FUNCTION room_search(HotelID integer, RoomStatus text, TypeName varchar(100)) OWNER TO engeo;