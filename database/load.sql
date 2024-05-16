--Load hotel chains into DB (must be run in psql console)
\copy hotelchain FROM stdin;
Majestic Resorts    123 Mark Street, Harrisonburg, VA 22801
Amazing Resorts 456 Connor Street, Richmond, VA 20393
Great Hotels    789 Jackson Street, Bedford, VA 20183
\.;

--Load hotels into DB (must be run in psql console)
\copy hotel FROM 'C:\Users\jacks\OneDrive\Documents\School\engeo\database\MOCK_DATA_Hotel.csv' WITH DELIMITER ',';

--Load hotels into DB (must be run in psql console)
\copy Hotel_PhoneNum 
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\database\MOCK_DATA_Hotel_Phone.csv' 
    WITH DELIMITER ',';

--Load hotels into DB (must be run in psql console)
\copy Hotel_Feature
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\database\MOCK_DATA_Hotel_Features.csv' 
    WITH DELIMITER ',';

--Load hotels into DB (must be run in psql console)
\copy room
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\database\MOCK_DATA_Room.csv' 
    WITH DELIMITER ',';

--Load hotels into DB (must be run in psql console)
\copy Room_CurrentOccupantName
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\database\MOCK_DATA_Room_Current_Occ.csv' 
    WITH DELIMITER ',';

--Load hotels into DB (must be run in psql console)
\copy Room_FormerOccupantName
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\database\MOCK_DATA_Room_Former_occ.csv' 
    WITH DELIMITER ',';

--Load hotels into DB (must be run in psql console)
\copy RoomType
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\database\MOCK_DATA_Room_types.csv' 
    WITH DELIMITER ',';

--Load guests into DB (must be run in psql console)
\copy guest FROM 'C:\Users\clums\Documents\CS374\Project\engeo\data\guest.tsv' WITH DELIMITER '	';

--Load employees (must be run in psql console)
\copy employee (EmployeeID, HotelID, EmployeeName, PhoneNum, Address, DOB, IsManager) 
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\data\employees.tsv' 
    WITH DELIMITER '   ';

--Load rewards program (must be run in psql console)
\copy RewardsProgram FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\data\reward-program-data.tsv';

--Load bills into DB (must be run in psql console)
\copy Bill (BillID, GuestID, BillTotal, RoomNum, SeasonalPrice, HotelID) 
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\database\MOCK_DATA_Bill.csv' 
    WITH DELIMITER ',';

--Load bill charges into DB (must be run in psql console)
\copy Bill_Charge (BillID, Charge) 
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\data\MOCK_DATA_Bill_Charge.csv' 
    WITH DELIMITER ',';

--Load bill discounts into DB (must be run in psql console)
\copy Bill_Discount (BillID, Discount) 
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\data\MOCK_DATA_Bill_Discount.csv' 
    WITH DELIMITER ',';

--Load reward perks into DB (must be run in psql console)
\copy RewardPerk (PerkID, Perk, RewardTier) 
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\database\MOCK_DATA_RewardPerk.csv' 
    WITH DELIMITER ',';

--Load orders into DB (must be run in psql console)
\copy Orders (OrderID, RoomNum, GuestID, BillID, DeliveryDay, DeliveryTime, TotalPrice, Status) 
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\data\orders.tsv' 
    WITH DELIMITER '    ';

--Load reviews into DB (must be run in psql console)
\copy Review (DisplayName, HotelID, GuestID, Review, Score) 
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\data\reviews.tsv' 
    WITH DELIMITER '    ';

--Load cleaners into DB (must be run in psql console)
\copy Cleaner
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\data\cleaners.tsv'
    WITH DELIMITER '    ';

--Load cleaner assignments into DB (must be run in psql console)
\copy RoomsAssigned (EmployeeID, RoomAssigned) 
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\data\roomsassigned.tsv' 
    WITH DELIMITER '    ';

--Load administrator information into DB (must be run in psql console)
\copy Administrator (EmployeeID, IsReception, IsSecurity) 
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\data\administrators.tsv' 
    WITH DELIMITER '    ';

--Load maintenance into DB (must be run in psql console)
\copy Maintenance
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\data\maintenance.tsv'
    WITH DELIMITER '    ';

--Load maintenance assignments into DB (must be run in psql console)
\copy TasksAssigned (EmployeeID, TaskAssigned) FROM 
    'C:\Users\(username)\Documents\CS374\Project\engeo\data\tasksassigned.tsv' 
    WITH DELIMITER '    ';

--Load room type features into DB (must be run in psql console)
\copy TypeFeatures FROM '/Users/connordunn/School/Computer-Science/CS_374/Group-Project/engeo/data/typefeature.tsv';

--Load discount category for guests into DB (must be run in psql console)
\copy Guest_DiscountCategory (GuestID, DiscountCategory) FROM '/Users/connordunn/School/Computer-Science/CS_374/Group-Project/engeo/data/discountcat.tsv';

--Load discount category for guests into DB (must be run in psql console)
\copy Orders_OrderedItem FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\data\ordereditem.tsv' 
    WITH DELIMITER '    ';

--Load discount category for guests into DB (must be run in psql console)
\copy Reservation (BookingID, HotelID, GuestID, BookingDate, BookingStartDate, BookingEndDate, TypeName) 
    FROM '/Users/connordunn/School/Computer-Science/CS_374/Group-Project/engeo/data/reservations.tsv';

--Load room service menu into DB (must be run in psql console)
\copy OrderMenu (ItemName, Price) 
    FROM 'C:\Users\(username)\Documents\CS374\Project\engeo\data\ordermenu.tsv' 
    WITH DELIMITER '    ';