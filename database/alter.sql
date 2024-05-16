--------------------------------------------------------------------------------
---- Primary Keys ----
--------------------------------------------------------------------------------
ALTER TABLE HotelChain
    ADD PRIMARY KEY (ChainName);

ALTER TABLE Hotel
    ADD PRIMARY KEY (HotelID);

ALTER TABLE Hotel_Feature
    ADD PRIMARY KEY (HotelID, Feature);

ALTER TABLE Hotel_PhoneNum
    ADD PRIMARY KEY (HotelID, PhoneNum);

ALTER TABLE Employee
    ADD PRIMARY KEY (EmployeeID);

ALTER TABLE Cleaner
    ADD PRIMARY KEY (EmployeeID);

ALTER TABLE RoomsAssigned
    ADD PRIMARY KEY (EmployeeID, RoomAssigned);

ALTER TABLE Administrator
    ADD PRIMARY KEY (EmployeeID);

ALTER TABLE Maintenance
    ADD PRIMARY KEY (EmployeeID);

ALTER TABLE TasksAssigned
    ADD PRIMARY KEY (EmployeeID, TaskAssigned);

ALTER TABLE RoomType
    ADD PRIMARY KEY (HotelID, TypeName);

ALTER TABLE TypeFeatures
    ADD PRIMARY KEY (FeatureID);

ALTER TABLE Room
    ADD PRIMARY KEY (HotelID, RoomNum, Floor);

ALTER TABLE Room_CurrentOccupantName
    ADD PRIMARY KEY (Floor, RoomNum, HotelID, CurrentOccupantName);

ALTER TABLE Room_FormerOccupantName
    ADD PRIMARY KEY (Floor, RoomNum, HotelID, FormerOccupantName);

ALTER TABLE Bill
    ADD PRIMARY KEY (BillID);

ALTER TABLE Bill_Charge
    ADD PRIMARY KEY (BillID, Charge);

ALTER TABLE Bill_Discount
    ADD PRIMARY KEY (BillID, Discount);

ALTER TABLE RewardsProgram
    ADD PRIMARY KEY (GuestID, RewardTier);

ALTER TABLE RewardPerk
    ADD PRIMARY KEY (PerkID);

ALTER TABLE Reservation
    ADD PRIMARY KEY (BookingID);

ALTER TABLE Guest
    ADD PRIMARY KEY (GuestID);

ALTER TABLE Guest_DiscountCategory
    ADD PRIMARY KEY (GuestID, DiscountCategory);

ALTER TABLE Review
    ADD PRIMARY KEY (GuestID);

ALTER TABLE Orders
    ADD PRIMARY KEY (OrderID);

ALTER TABLE Orders_OrderedItem
    ADD PRIMARY KEY (OrderID, OrderedItem, LineNum);

ALTER TABLE OrderMenu
    ADD PRIMARY KEY (ItemName);

--------------------------------------------------------------------------------
-- Foreign Keys --
--------------------------------------------------------------------------------
ALTER TABLE Bill
    ADD FOREIGN KEY (HotelID)
    REFERENCES Hotel (HotelID);

ALTER TABLE Hotel
    ADD FOREIGN KEY (ChainName)
    REFERENCES HotelChain (ChainName);

ALTER TABLE RoomType
    ADD FOREIGN KEY (HotelID)
    REFERENCES Hotel (HotelID);

ALTER TABLE Orders
    ADD FOREIGN KEY (GuestID)
    REFERENCES Guest (GuestID);

ALTER TABLE Bill
    ADD FOREIGN KEY (GuestID)
    REFERENCES Guest (GuestID);


ALTER TABLE Reservation
    ADD FOREIGN KEY (HotelID)
    REFERENCES Hotel (HotelID);

ALTER TABLE Employee
    ADD FOREIGN KEY (HotelID)
    REFERENCES Hotel (HotelID);

ALTER TABLE Cleaner
    ADD FOREIGN KEY (EmployeeID)
    REFERENCES Employee (EmployeeID);

ALTER TABLE Administrator
    ADD FOREIGN KEY (EmployeeID)
    REFERENCES Employee (EmployeeID);

ALTER TABLE Maintenance
    ADD FOREIGN KEY (EmployeeID)
    REFERENCES Employee (EmployeeID);

ALTER TABLE Room
    ADD FOREIGN KEY (HotelID)
    REFERENCES Hotel (HotelID);

ALTER TABLE Room
    ADD FOREIGN KEY (GuestID)
    REFERENCES Guest (GuestID);

ALTER TABLE Room
    ADD FOREIGN KEY (BookingID)
    REFERENCES Reservation (BookingID);

ALTER TABLE Review
    ADD FOREIGN KEY (GuestID)
    REFERENCES Guest (GuestID);

ALTER TABLE Review
    ADD FOREIGN KEY (HotelID)
    REFERENCES Hotel (HotelID);

ALTER TABLE Orders_OrderedItem
    ADD FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

ALTER TABLE Bill_Discount
    ADD FOREIGN KEY (BillID)
    REFERENCES Bill (BillID);

ALTER TABLE Bill_Charge
    ADD FOREIGN KEY (BillID)
    REFERENCES Bill (BillID);

ALTER TABLE Guest_DiscountCategory
    ADD FOREIGN KEY (GuestID)
    REFERENCES Guest (GuestID);

ALTER TABLE Hotel_Feature
    ADD FOREIGN KEY (HotelID)
    REFERENCES Hotel (HotelID);

ALTER TABLE Hotel_PhoneNum
    ADD FOREIGN KEY (HotelID)
    REFERENCES Hotel (HotelID);

ALTER TABLE RewardsProgram
    ADD FOREIGN KEY (GuestID)
    REFERENCES Guest (GuestID);
    
ALTER TABLE Room_FormerOccupantName
    ADD FOREIGN KEY (RoomNum, Floor, HotelID)
   REFERENCES Room (RoomNum, Floor, HotelID);

ALTER TABLE Room_CurrentOccupantName
    ADD FOREIGN KEY (RoomNum, Floor, HotelID)
    REFERENCES Room (RoomNum, Floor, HotelID);

ALTER TABLE RoomsAssigned
    ADD FOREIGN KEY (EmployeeID)
    REFERENCES Cleaner (EmployeeID);

ALTER TABLE TasksAssigned
    ADD FOREIGN KEY (EmployeeID)
    REFERENCES Maintenance (EmployeeID);

ALTER TABLE TypeFeatures
    ADD FOREIGN KEY (HotelID, TypeName)
    REFERENCES RoomType (HotelID, TypeName);

ALTER TABLE Orders_OrderedItem
    ADD FOREIGN KEY (OrderedItem)
    REFERENCES OrderMenu (ItemName);

--------------------------------------------------------------------------------
-- Indexes
--------------------------------------------------------------------------------

