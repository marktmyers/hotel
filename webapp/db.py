
import psycopg
import socket
import datetime


# Determine whether running on/off campus
# Note: PGUSER and PGPASSWORD must be set
try:
    socket.gethostbyname("data.cs.jmu.edu")
    DSN = "host=data.cs.jmu.edu dbname=engeo"
except:
    DSN = "host=localhost dbname=engeo"


def room_search(hotel_id, room_status, room_type):
    with psycopg.connect(DSN) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM room_search(%s, %s, %s)", (hotel_id, room_status, room_type))
            return cur.fetchall()
        
def room_book(hotel_id, floor_num, room_num, guest_id, guest_name_1, guest_name_2, guest_name_3, guest_name_4):
    with psycopg.connect(DSN) as conn:
        with conn.cursor() as cur:
            # Update guestId for selected room
            update_room_query = """
                UPDATE Room
                SET GuestID = %s
                WHERE HotelID = %s AND Floor = %s AND RoomNum = %s
            """
            cur.execute(update_room_query, (guest_id, hotel_id, floor_num, room_num))

            # Clear current occupants from table
            clear_current_occupants_query = """
                DELETE FROM Room_CurrentOccupantName
                WHERE RoomNum = %s AND Floor = %s AND HotelID = %s
            """
            cur.execute(clear_current_occupants_query, (room_num, floor_num, hotel_id))

            # Insert new guest names into selected table
            current_occupants = [guest_name_1, guest_name_2, guest_name_3, guest_name_4]
            for name in current_occupants:
                if name:
                    insert_current_occupant_query = """
                        INSERT INTO Room_CurrentOccupantName (RoomNum, Floor, HotelID, CurrentOccupantName)
                        VALUES (%s, %s, %s, %s)
                    """
                    cur.execute(insert_current_occupant_query, (room_num, floor_num, hotel_id, name))
            # Get the current date
            current_date = datetime.date.today()

            # Insert new guest names into selected table
            former_occupants = [guest_name_1, guest_name_2, guest_name_3, guest_name_4]
            for name in former_occupants:
                if name:
                    insert_former_occupant_query = """
                        INSERT INTO Room_FormerOccupantName (RoomNum, Floor, HotelID, StayDate, FormerOccupantName)
                        VALUES (%s, %s, %s, %s, %s)
                    """
                    cur.execute(insert_former_occupant_query, (room_num, floor_num, hotel_id, current_date, name))

def view_reviews(hotelname):
    with psycopg.connect(DSN) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM view_reviews(%s)", 
                        ([hotelname]))
            return cur.fetchall()

def show_orders(guestid):
    with psycopg.connect(DSN) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM show_orders(%s)",
                        ([guestid]))
            return cur.fetchall()

def order_menu():
    with psycopg.connect(DSN) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM OrderMenu")
            return cur.fetchall()

def place_order(guest_id, item_name, delivery_time, room_num):
    with psycopg.connect(DSN) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM Guest WHERE guestid = %s", ([guest_id]))
            check_guest = cur.fetchone()
            if (check_guest == None):
                return 1
            cur.execute("SELECT * FROM OrderMenu WHERE OrderMenu.ItemName = %s", ([item_name]))
            check_item = cur.fetchone()
            if check_item == None:
                return 2
            cur.execute("SELECT MAX(orders.orderid) FROM orders")
            new_id = cur.fetchone()
            if new_id[0] != None:
                new_id = new_id[0]+1
            else:
                new_id = 1
            status = "IN PROGRESS"
            cur.execute("SELECT Price from OrderMenu WHERE OrderMenu.ItemName = %s",
                        ([item_name]))
            total_price = cur.fetchone()
            if total_price != None:
                total_price = total_price[0]
            else:
                total_price = None
                return 2
            delivery_day = "2024-04-01"
            cur.execute("SELECT * FROM orders WHERE orders.guestid = %s", ([guest_id]))
            check_existing = cur.fetchone()
            if (check_existing == None): # Guest hasn't ordered room service yet, create a new order object.
                sql = "INSERT INTO orders VALUES (%s, %s, %s, %s, %s, %s, %s)"
                args = (new_id, room_num, guest_id, delivery_day, delivery_time, total_price, status)
                cur.execute(sql, args)
            else: # Guest has ordered room service, add to existing order.
                cur.execute("SELECT orderid FROM orders WHERE guestid = %s",
                            ([guest_id]))
                new_id = cur.fetchone()[0]
                cur.execute("SELECT totalprice FROM orders WHERE orderid = %s",
                            ([new_id]))
                current_cost = cur.fetchone()[0]
                current_cost = current_cost + total_price
                cur.execute("UPDATE orders SET totalprice = %s WHERE orderid = %s", ([current_cost, new_id]))
            cur.execute("SELECT MAX(linenum) FROM Orders_OrderedItem WHERE orderid = %s",
                        ([new_id]))
            getlinenum = cur.fetchone()
            if (getlinenum == None): # No items ordered
                linenum = 0
            else:
                linenum = getlinenum[0] + 1
            sql = "INSERT INTO orders_ordereditem VALUES (%s, %s, %s, %s)"
            args = (new_id, item_name, total_price, linenum)
            cur.execute(sql, args)


def bill_search(guest_id):
   with psycopg.connect(DSN) as conn:
       with conn.cursor() as cur:
           cur.execute("SELECT * FROM bill_search(%s)", ([guest_id]))
           bills = cur.fetchall()
           return bills


def reservations_search(hotel, bookingstartdate, bookingenddate):
    with psycopg.connect(DSN) as conn:
        with conn.cursor() as cur:
            print(hotel)
            cur.execute("SELECT hotelid FROM hotel WHERE hotelname = %s",
                        ([hotel]))
            hotelid = cur.fetchone()[0]
            print(hotelid)
            cur.execute("SELECT * FROM reservations_search(%s, %s, %s)",
                        ([hotelid, bookingstartdate, bookingenddate]))
            return cur.fetchall()


def make_reservation(hotel, room_types, bookingstartdate, bookingenddate, guestid):
    with psycopg.connect(DSN) as conn:
        with conn.cursor() as cur:

            cur.execute("SELECT hotelid FROM hotel WHERE hotelname = %s",
                        ([hotel]))
            hotelid = cur.fetchone()[0]

            cur.execute("SELECT bookingid FROM reservation ORDER BY bookingid DESC LIMIT 1")
            bookingid = cur.fetchone()[0]
            bookingid += 1

            sql = "INSERT INTO reservation VALUES (%s, %s, %s, now(), %s, %s, %s)"
            
            for i in range(len(room_types)):
                args = (bookingid + i, hotelid, guestid, bookingstartdate, bookingenddate, room_types[i])
                cur.execute(sql, args)  # will wait if table is locked

            # Information to be displayed
            return hotel, room_types

def checkout_guest(room_num, hotel_id):
    with psycopg.connect(DSN) as conn:
        with conn.cursor() as cur:
            # Update room status
            cur.execute("""
                UPDATE Room
                SET GuestID = NULL, RoomStatus = 'Ready for cleaning'
                WHERE RoomNum = %s AND HotelID = %s
            """, (room_num, hotel_id))

            # Transfer current occupants to former occupants
            cur.execute("""
                INSERT INTO Room_FormerOccupantName (RoomNum, HotelID, FormerOccupantName)
                SELECT RoomNum, HotelID, CurrentOccupantName
                FROM Room_CurrentOccupantName
                WHERE RoomNum = %s AND HotelID = %s
            """, (room_num, hotel_id))

            cur.execute("""
                DELETE FROM Room_CurrentOccupantName
                WHERE RoomNum = %s AND HotelID = %s
            """, (room_num, hotel_id))

            # Generate and return itemized bill
            cur.execute("""
                SELECT BillID, (BillTotal + COALESCE(SUM(Charge), 0) - COALESCE(SUM(Discount), 0)) AS TotalCost
                FROM Bill
                LEFT JOIN Bill_Charge ON Bill.BillID = Bill_Charge.BillID
                LEFT JOIN Bill_Discount ON Bill.BillID = Bill_Discount.BillID
                WHERE GuestID = (SELECT GuestID FROM Room WHERE RoomNum = %s AND HotelID = %s)
                GROUP BY Bill.BillID, BillTotal
            """, (room_num, hotel_id))
            bill_details = cur.fetchone()
            return bill_details

def update_guest_bills(guest_id):
   with psycopg.connect(DSN) as conn:
       with conn.cursor() as cur:
           try:
               # Set related Bill_Charge entries to zero
               cur.execute("""
                   UPDATE Bill_Charge
                   SET Charge = 0
                   WHERE BillID IN (SELECT BillID FROM Bill WHERE GuestID = %s)
               """, (guest_id,))
              
               # Set related Bill_Discount entries to zero
               cur.execute("""
                   UPDATE Bill_Discount
                   SET Discount = 0
                   WHERE BillID IN (SELECT BillID FROM Bill WHERE GuestID = %s)
               """, (guest_id,))


               # Set BillTotal to zero
               cur.execute("""
                   UPDATE Bill
                   SET BillTotal = 0
                   WHERE GuestID = %s
               """, (guest_id,))


               conn.commit()
           except Exception as e:
               print("Failed to update bills for guest ID:", guest_id, "Error:", e)
               conn.rollback()
               raise

def fetch_guest_bills(guest_id):
   with psycopg.connect(DSN) as conn:
       with conn.cursor() as cur:
           cur.execute("""
               SELECT Bill.BillID, BillTotal, COALESCE(SUM(Charge), 0) AS TotalCharges, COALESCE(SUM(Discount), 0) AS TotalDiscounts
               FROM Bill
               LEFT JOIN Bill_Charge ON Bill.BillID = Bill_Charge.BillID AND Bill_Charge.Charge > 0
               LEFT JOIN Bill_Discount ON Bill.BillID = Bill_Discount.BillID AND Bill_Discount.Discount > 0
               WHERE GuestID = %s
               GROUP BY Bill.BillID, BillTotal
               HAVING COALESCE(SUM(Charge), 0) > 0 OR COALESCE(SUM(Discount), 0) > 0 OR BillTotal > 0
           """, (guest_id,))
           bills = cur.fetchall()
           return bills
