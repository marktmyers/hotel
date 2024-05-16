--
-- Query 1 -- Ill probably have to use EXCEPT instead of this
--

DROP FUNCTION IF EXISTS reservations_search(HotelID integer, BookingStartDate date, BookingEndDate date);

CREATE FUNCTION reservations_search(HotelID integer, BookingStartDate date, BookingEndDate date)
RETURNS SETOF RoomType AS $$

  SELECT rt.typename, AVG(r.roomprice) AS avg_cost_per_night
  FROM roomtype rt
	  JOIN reservation rsv USING(hotelid)
	  JOIN room r ON rt.hotelid = r.hotelid AND rt.typename = r.typename
  WHERE rt.hotelid = $1
      AND rt.typename NOT IN (
        SELECT r2.typename
        FROM reservation r2
        WHERE r2.hotelid = $1
            AND (r2.bookingstartdate = $2
                 OR r2.bookingenddate = $3)
      )
  GROUP BY rt.typename;

$$ LANGUAGE SQL STABLE STRICT;

ALTER FUNCTION reservations_search(HotelID integer, BookingStartDate date, BookingEndDate date) OWNER TO absent;
