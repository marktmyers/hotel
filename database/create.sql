--------------------------------------------------------------------------------
-- Drop Tables --
--------------------------------------------------------------------------------

DROP TABLE IF EXISTS HotelChain CASCADE;
DROP TABLE IF EXISTS Hotel CASCADE;
DROP TABLE IF EXISTS Hotel_Feature CASCADE;
DROP TABLE IF EXISTS Hotel_PhoneNum CASCADE;
DROP TABLE IF EXISTS Employee CASCADE;
DROP TABLE IF EXISTS Cleaner CASCADE;
DROP TABLE IF EXISTS RoomsAssigned CASCADE;
DROP TABLE IF EXISTS Administrator CASCADE;
DROP TABLE IF EXISTS Maintenance CASCADE;
DROP TABLE IF EXISTS TasksAssigned CASCADE;
DROP TABLE IF EXISTS RoomType CASCADE;
DROP TABLE IF EXISTS TypeFeatures CASCADE;
DROP TABLE IF EXISTS Room CASCADE;
DROP TABLE IF EXISTS Room_CurrentOccupantName CASCADE;
DROP TABLE IF EXISTS Room_FormerOccupantName CASCADE;
DROP TABLE IF EXISTS Bill CASCADE;
DROP TABLE IF EXISTS Bill_Charge CASCADE;
DROP TABLE IF EXISTS Bill_Discount CASCADE;
DROP TABLE IF EXISTS RewardsProgram CASCADE;
DROP TABLE IF EXISTS RewardPerk CASCADE;
DROP TABLE IF EXISTS Reservation CASCADE;
DROP TABLE IF EXISTS Guest CASCADE;
DROP TABLE IF EXISTS Guest_DiscountCategory CASCADE;
DROP TABLE IF EXISTS Review CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Orders_OrderedItem CASCADE;
DROP TABLE IF EXISTS RoomService CASCADE;
DROP TABLE IF EXISTS RoomService_ActiveOrders CASCADE;
DROP TABLE IF EXISTS RoomService_PastOrders CASCADE;
DROP TABLE IF EXISTS OrderMenu CASCADE;

--------------------------------------------------------------------------------
-- Create Tables
--------------------------------------------------------------------------------

CREATE TABLE HotelChain
(
	ChainName varchar(100) UNIQUE NOT NULL,
	Address varchar(100) NOT NULL
);
COMMENT ON TABLE HotelChain
    IS 'Hotel Chain Table (chain owns certain hotels)';
ALTER TABLE HotelChain OWNER TO engeo;

CREATE TABLE Hotel
(
	HotelID serial UNIQUE NOT NULL,
	ChainName varchar(100),
	HotelName varchar(100) NOT NULL,
	Address varchar(100) NOT NULL
);
COMMENT ON TABLE Hotel 
	IS 'Hotel table';
ALTER TABLE Hotel OWNER TO engeo;

CREATE TABLE Hotel_Feature
(
	HotelID integer NOT NULL,
	Feature varchar(100)
);
COMMENT ON TABLE Hotel_Feature
	IS 'Features of a hotel.';
ALTER TABLE Hotel_Feature OWNER TO engeo;

CREATE TABLE Hotel_PhoneNum
(
	HotelID integer NOT NULL,
	PhoneNum varchar(15) UNIQUE NOT NULL
);
COMMENT ON TABLE Hotel_PhoneNum
	IS 'Phone number for the hotel.';
ALTER TABLE Hotel_PhoneNum OWNER TO engeo;

CREATE TABLE Employee
(
	EmployeeID serial UNIQUE NOT NULL,
	HotelID integer NOT NULL,
	EmployeeName varchar(100) NOT NULL,
	PhoneNum varchar(10) NOT NULL,
	Address varchar(100) NOT NULL,
	DOB date NOT NULL,
	IsManager boolean NOT NULL
);
COMMENT ON TABLE Employee
    IS 'Employee table';
ALTER TABLE Employee OWNER TO engeo;

CREATE TABLE Cleaner
(
	EmployeeID integer UNIQUE NOT NULL
);
COMMENT ON TABLE Cleaner
    IS 'Cleaner employee table';
ALTER TABLE Cleaner OWNER TO engeo;

CREATE TABLE RoomsAssigned
(
	EmployeeID integer UNIQUE NOT NULL,
	RoomAssigned integer NOT NULL
);
COMMENT ON TABLE RoomsAssigned
	IS 'Rooms that are assigned to be cleaned by a cleaner.';
ALTER TABLE RoomsAssigned OWNER TO engeo;

CREATE TABLE Administrator
(
	EmployeeID integer UNIQUE NOT NULL,
	IsReception boolean NOT NULL,
	IsSecurity boolean NOT NULL
);
COMMENT ON TABLE Administrator
    IS 'Administrator employee table';
ALTER TABLE Administrator OWNER TO engeo;

CREATE TABLE Maintenance
(
	EmployeeID integer UNIQUE NOT NULL
);
COMMENT ON TABLE Maintenance
    IS 'Maintenance employee table';
ALTER TABLE Maintenance OWNER TO engeo;

CREATE TABLE TasksAssigned
(
	EmployeeID integer UNIQUE NOT NULL,
	TaskAssigned text NOT NULL
);
COMMENT ON TABLE TasksAssigned
	IS 'Tasks assigned to a maintenance personnel';
ALTER TABLE TasksAssigned OWNER TO engeo;

CREATE TABLE RoomType
(
	HotelID integer NOT NULL,
	TypeName varchar(100) NOT NULL,
	TypeCapacity integer NOT NULL
);
COMMENT ON TABLE RoomType
    IS 'Room type table';
ALTER TABLE RoomType OWNER TO engeo;

CREATE TABLE TypeFeatures
(
	FeatureID integer UNIQUE NOT NULL,
	HotelID integer NOT NULL,
	TypeName varchar(100) NOT NULL,
	Amenity varchar(100) NOT NULL
);
COMMENT ON TABLE TypeFeatures
	IS 'Features of a room type.';
ALTER TABLE TypeFeatures OWNER TO engeo;

CREATE TABLE Room
(
	RoomNum integer NOT NULL,
	Floor integer NOT NULL,
	RoomPrice integer NOT NULL,
	RoomStatus text NOT NULL, 
	GuestID integer NOT NULL,
	BookingID integer NOT NULL,
	HotelID integer NOT NULL,
	TypeName varchar(100) NOT NULL
);
COMMENT ON TABLE Room 
	IS 'room table';
ALTER TABLE Room OWNER TO engeo;

CREATE TABLE Room_CurrentOccupantName
(
	RoomNum integer NOT NULL,
	Floor integer NOT NULL,
	HotelID integer NOT NULL,
	CurrentOccupantName varchar(100)
);
COMMENT ON TABLE Room_CurrentOccupantName
	IS 'Occupants of a room';
ALTER TABLE Room_CurrentOccupantName OWNER TO engeo;

CREATE TABLE Room_FormerOccupantName
(
	RoomNum integer NOT NULL,
	Floor integer NOT NULL,
	HotelID integer NOT NULL,
	StayDate date NOT NULL,
	FormerOccupantName varchar(100)
);
COMMENT ON TABLE Room_FormerOccupantName
	IS 'Former occupants of a room';
ALTER TABLE Room_FormerOccupantName OWNER TO engeo;

CREATE TABLE Bill
(
	BillID serial UNIQUE NOT NULL,
	GuestID integer UNIQUE NOT NULL,
	BillTotal  integer NOT NULL,
	RoomNum integer NOT NULL,
	SeasonalPrice integer NOT NULL,
	HotelID integer NOT NULL
);
COMMENT ON TABLE Bill
    IS 'Bill table';
ALTER TABLE Bill OWNER TO engeo;

CREATE TABLE Bill_Charge
(
	BillID integer NOT NULL,
	Charge integer NOT NULL
);
COMMENT ON TABLE Bill_Charge
	IS 'Charge added to bill';
ALTER TABLE Bill_Charge OWNER TO engeo;

CREATE TABLE Bill_Discount
(
	BillID integer NOT NULL,
	Discount integer NOT NULL
);
COMMENT ON TABLE Bill_Discount
	IS 'Discounts off of bill';
ALTER TABLE Bill_Discount OWNER TO engeo;

CREATE TABLE RewardsProgram
(
	RewardTier integer NOT NULL,
	GuestID integer UNIQUE NOT NULL
);
COMMENT ON TABLE RewardsProgram
    IS 'Rewards program table';
ALTER TABLE RewardsProgram OWNER TO engeo;

CREATE TABLE RewardPerk
(
	PerkID integer UNIQUE NOT NULL,
    Perk text NOT NULL,
    RewardTier integer NOT NULL
);
COMMENT ON TABLE RewardPerk
	IS 'Perk of a reward tier';
ALTER TABLE RewardPerk OWNER to engeo;

CREATE TABLE Reservation
(
	BookingID serial UNIQUE NOT NULL,
	HotelID integer NOT NULL,
	GuestID integer NOT NULL,
	BookingDate date NOT NULL,
	BookingStartDate date NOT NULL,
	BookingEndDate date NOT NULL,
	TypeName varchar(100) NOT NULL
);
COMMENT ON TABLE Reservation
    IS 'Reservation table';
ALTER TABLE Reservation OWNER TO engeo;

CREATE TABLE Guest
(
	GuestID serial UNIQUE NOT NULL,
	IDType varchar(100) NOT NULL,
	IDNum integer NOT NULL,
	BillID integer NOT NULL,
	BookingID integer NOT NULL,
	Address varchar(100) NOT NULL,
	RewardsTier integer NOT NULL,
	HomePhone varchar(10) NOT NULL,
	MobilePhone varchar(10) NOT NULL
);
COMMENT ON TABLE Guest
    IS 'Guest table';
ALTER TABLE Guest OWNER TO engeo;

CREATE TABLE Guest_DiscountCategory
(
	GuestID integer UNIQUE NOT NULL,
	DiscountCategory varchar(50)
);
COMMENT ON TABLE Guest_DiscountCategory
	IS 'Discounts a guest qualifies for.';
ALTER TABLE Guest_DiscountCategory OWNER TO engeo;

CREATE TABLE Review
(
	DisplayName varchar(100) UNIQUE NOT NULL,
	HotelID integer NOT NULL,
	GuestID integer UNIQUE NOT NULL,
	Review text NOT NULL,
	Score integer NOT NULL
);
COMMENT ON TABLE Review
    IS 'Review table';
ALTER TABLE Review OWNER TO engeo;

CREATE TABLE Orders
(
	OrderID serial UNIQUE NOT NULL,
	RoomNum integer NOT NULL,
	GuestID integer UNIQUE NOT NULL,
	DeliveryDay varchar(10) NOT NULL,
	DeliveryTime varchar(5) NOT NULL,
	TotalPrice integer NOT NULL,
	Status varchar(60) NOT NULL
);
COMMENT ON TABLE Orders
    IS 'Order table';
ALTER TABLE Orders OWNER TO engeo;

CREATE TABLE Orders_OrderedItem
(
	OrderID integer NOT NULL,
	OrderedItem varchar(50) NOT NULL,
	ItemPrice integer,
	LineNum integer NOT NULL
);
COMMENT ON TABLE Orders_OrderedItem
	IS 'Items in an order';
ALTER TABLE Orders_OrderedItem OWNER TO engeo;

CREATE TABLE OrderMenu
(
	ItemName varchar(50) UNIQUE NOT NULL,
	Price integer NOT NULL
);
COMMENT ON TABLE OrderMenu
	IS 'Menu for room service';
ALTER TABLE OrderMenu OWNER TO engeo;
