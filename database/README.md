# Database

## File contents

* create.sql -- drops and creates all tables
* alter.sql -- adds all primary and foreign keys
* eer_model.png -- EER diagram from [draw.io](https://www.drawio.com/)
* rel_model.pgerd -- relational ERD (pgAdmin)

## Building the database

Define environment variables:

``` sh
export PGHOST=data.cs.jmu.edu
export PGDATABASE=engeo
export PGUSER=jmu_username
export PGPASSWORD=student_number
```

Run the following commands:

``` sh
psql < create.sql
psql < alter.sql
```
## Load file
* Since we were using a mix of macs and windows in our group. Everyone individually copied the file path and 
* then loaded up their data. This may require anyone to cpy their own path into the load statement then run it in pgadmin in the psql tool


## Changes to EER model
* Address in the hotel table is no longer multi-valued
* Billing history is derived in guest
* Review is only identified by the DisplayName
* Room service no longer includes menuitems
* added attributes that were implemented while working on the database

## Relational model decisions
* We decided that it would be best to have cleaners, administrators, and maintenance in separate
* tables rather than having them all in 1 table because that would lead to too many booleans in
* employee.
* We made every multi-valued attribute its own table.


## GP3 data adding decisions
* Hotel - only 20 hotels so generated data fit well
* Hotel phone num - generated data fit, manually added some extra phone numbers to some hotels
* Hotel feature - generated data most valid except for repeated room features for the same hotel so i had to search the file and switch those features accordingly
* Room- generated data mostly valid, only slight changes needed to roomnum/ floor combo since floors can match and hotels can. The cobination of the both of them must be unique
* Room current occupant name - cant have repeating rooms since its the current occupant of the room so once data was generated, I had to manual go through and search in the file for duplicate room numbers and then change the hotel or room to be different
* Room former occupant name - could be repeating names so no need to alter the generated data
* Room type- each room type has its own specific room capacity for each hotel ID
* Bill - Numbers were used to get the amounts for the charges and I used 1 - 2000 for potential totals. I also used 100-500 to simulate room numbers. Also, the ein fields had a '-' character in them so I got rid of those to fit the database.
* Bill Charge - I used row numbers for the bill id field because each id should be different and it makes sense to have them increment for each charge.
* Bill Discount - I used numbers between 1 - 1000 for discounts so that it would not exceed the total of the bill. I also went in and manually changed most of the numbers to 0 so that most bills would not have a discount.
* Room service - I used numbers between 100 - 99999 to get ids for the orders to simulate order ids to go back to.
* Room service active orders - I used the ai feature of mockaroo to get a list of foods that could be ordered for room service
* Room service past orders - I used the same ai list from the last table to get the list for this table
* Reward perk - I also used ai to get possible perks for a hotel. I also used numbers between 1 - 3 to get the tier of the reward.
* Guest - I used mockaroo to generate the guest data. GuestID was created using the row number category.
* Employee - I used mockaroo to generate the employee data. EmployeeID was created using the row number category. HotelID ranges from 1-20 (in order to correspond with hotels).
* Cleaner/RoomsAssigned - I used mockaroo to generate the cleaner data. I used row numbers as EmployeeIDs to assign rooms to employees.
* Maintenance/TasksAssigned - I used mockaroo to generate the maintenance data. I used row numbers + 20 (via the sigma feature) as EmployeeIDs to assign tasks to employees.
* Administrator - I used mockaroo to generate the administrator data. I used row numbers as EmployeeIDs + 10 (via the sigma feature) as EmployeeIDs to decide an administrator's roles.
* Orders - I used mockaroo to generate orders. I used row numbers for any field that needs to be a unique integer (GuestID, BillID, etc). Dates cannot be later than 4/1/2024. Since DeliveryTime is a timestamp, the format of input to that field must be 'yyyy-mm-dd hh:mm'.
* Review - I used mockaroo to generate reviews. I used row numbers for guestID, and HotelID is a random integer between 1 and 20 (so they correspond with existing hotels).

# GP4/5/6 - Queries And Charts
* The flask app can be run by first creating a Python virtual environment, running .venv\Scripts\Activate, and then using flask --app app run.
* Functions can be created for a database just by running them in pgAdmin.
* all sql functions must be executed in pgadmin before running the webapp
* must provide the username and password to login to the database connection for website to work
