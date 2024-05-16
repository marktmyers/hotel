--
-- Queries the database to get all the reviews for a hotel.
--

DROP FUNCTION IF EXISTS view_reviews(Review_HotelName varchar(100));
CREATE FUNCTION view_reviews(Review_HotelName varchar(100))
RETURNS TABLE (DN varchar(100), HID integer, GID integer, R text, S integer) AS $func$

    SELECT *
    FROM Review
    WHERE Review.HotelID = (
		SELECT HotelID
		FROM Hotel
		WHERE HotelName = Review_HotelName
	)

$func$ LANGUAGE SQL STABLE STRICT; 

ALTER FUNCTION view_reviews(Review_HotelName varchar(100)) OWNER TO engeo;