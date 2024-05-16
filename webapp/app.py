"""Example web application for postgres_air."""

from flask import Flask, request, render_template, redirect, flash
from psycopg import DatabaseError
import db

app = Flask(__name__)
app.secret_key = "dev"


@app.route("/")
def index():
    return "<a href='show_orders'>show_orders</a><br><a href='room_search'>room_search</a><br><a href='reservations_search'>reservations_search</a><br><a href='bill_search'>bill_search</a><br><a href='order_menu'>order_menu</a><br><a href='place_order'>place_order</a>"

@app.route("/room_search")
def room_search():
    # Get search parameters from query 
    hotel_id = request.args.get("hotel_id", type=int)
    room_status = request.args.get("room_status", type=str)
    room_type = request.args.get("room_type", type=str)
    
    if request.args:
        data = db.room_search(hotel_id, room_status, room_type)
    else:
        data = None
    return render_template('room_search.jinja', hotel_id=hotel_id, room_status=room_status, room_type=room_type, data=data)

@app.route("/room_book", methods=["GET", "POST"])
def room_book():
    if request.method == "POST":
        hotel_id = request.form.get("hotel_id", type=int)
        floor_num_db = request.form.get("floor_num", type=int)
        room_num_db = request.form.get("room_num", type=int)
        floor_num = request.form.get("floor_number", type=int)
        room_num = request.form.get("room_number", type=int)
        guest_id = request.form.get("guest_id", type=int)
        
        guest_name_1 = request.form.get("guest_name_1", type=str)
        guest_name_2 = request.form.get("guest_name_2", type=str)
        guest_name_3 = request.form.get("guest_name_3", type=str)
        guest_name_4 = request.form.get("guest_name_4", type=str)
        
        if guest_name_1 and guest_name_2 and guest_name_3 and guest_name_4:
            try:
                db.room_book(hotel_id, floor_num_db, room_num_db, guest_id, guest_name_1, guest_name_2, guest_name_3, guest_name_4)
                flash(f"Successfully booked room {room_num_db} on floor {floor_num_db} for {guest_name_1}")
            except DatabaseError as error:
                flash(error)
    
    return render_template("room_book.jinja", hotel_id=hotel_id, floor_num=floor_num, room_num=room_num,guest_id=guest_id, guest_name_1=guest_name_1, guest_name_2=guest_name_2, guest_name_3=guest_name_3, guest_name_4=guest_name_4)

@app.route("/show_orders")
def show_orders():
    # Get Bill ID to show orders on that bill.
    guestid = request.args.get("guestid")
    # If the user submitted the form
    if request.args:
        data = db.show_orders(guestid)
    else:
        data = None
    return render_template("show_orders.jinja", guestid=guestid, data=data)

@app.route("/order_menu")
def order_menu():
    data = db.order_menu()
    return render_template("order_menu.jinja", data=data)

@app.route("/place_order")
def place_order():
    item_name = request.args.get("item_name", "Choose an item:")
    guest_id = request.args.get("guest_id", "Guest ID")
    delivery_time = request.args.get("delivery_time", "Delivery Time")
    room_num = request.args.get("room_num", "Room Number")
    if item_name and guest_id and delivery_time and room_num:
        try:
            guest_id = int(guest_id)
            room_num = int(room_num)
            data = db.place_order(guest_id, item_name, delivery_time, room_num)
            if data == 1:
                flash("Invalid guest ID. Please try again.")
                data = None
            elif data == 2:
                flash("Invalid item. Please try again.")
                data = None
            else:
                success_output = f"Successfully placed order for {item_name}, to room {room_num}, at time {delivery_time}"
                flash(success_output)
        except ValueError:
            data = None
        except DatabaseError as error:
            error_output = "An error has occurred; please check your guest id and item and try again."
            flash(error_output)
            data = None
    else:
        data = None
    return render_template("place_order.jinja", item_name=item_name, 
                           guest_id=guest_id, delivery_time=delivery_time,
                           room_num=room_num, data=data)

@app.route("/bill_search")
def bill_search():
   guest_id = request.args.get("guest_id")
   bills = []
   if guest_id:
       try:
           guest_id = int(guest_id)
           bills = db.bill_search(guest_id) or []
       except ValueError:
           flash("Invalid input for guest ID. Please enter a valid number.", 'error')
       except Exception as e:
           flash(str(e), 'error')
   return render_template("bill_search.jinja", guest_id=guest_id, bills=bills)

@app.route("/reservations_search")
def reservation_search():
    # Get search parameters from query 
    hotel = request.args.get("hotel", type=str)
    bookingstartdate = request.args.get("bookingstartdate", type=str)
    bookingenddate = request.args.get("bookingenddate", type=str)
    
    if request.args:
        data = db.reservations_search(hotel, bookingstartdate, bookingenddate)
    else:
        data = None
    return render_template('reservations_search.jinja', hotel=hotel, bookingstartdate=bookingstartdate,
                            bookingenddate=bookingenddate, data=data)

@app.route("/make_reservation")
def make_reservation():
    # Make sure a hotel was selected
    hotel = request.args.get("hotel", "")
    
    # Get inputs from this page's form
    room_types = request.args.getlist('roomtype') 
    bookingstartdate = request.args.get("bookingstartdate", "")
    bookingenddate = request.args.get("bookingenddate", "")
    guestid = request.args.get("guestid", "")

    if not hotel and room_types and bookingstartdate and bookingenddate:
        return redirect("/reservation_search")
    
    if guestid:
        try:
            name, ref = db.make_reservation(hotel, room_types, bookingstartdate, bookingenddate, guestid)
            flash(f"Successfully booked {name} ({ref})")
        except DatabaseError as error:
            flash(error)
    return render_template("make_reservation.jinja", hotel=hotel,
                           room_types=room_types, bookingstartdate=bookingstartdate,
                            guestid=guestid, bookingenddate=bookingenddate)

@app.route("/checkout", methods=['POST'])
def checkout():
   guest_id = request.form.get('guest_id')
   if guest_id:
       try:
           guest_id = int(guest_id)
           db.update_guest_bills(guest_id) 
           bill_details = db.fetch_guest_bills(guest_id) 
           if bill_details:
               flash("Checkout successful. All charges have been cleared.")
               return redirect("/")
           else:
               flash("No active bills found for this guest, or all charges/discounts are set to 0.")
               return redirect("/")
       except ValueError:
           flash("Invalid guest ID provided.")
           return "Invalid guest ID. Please enter a valid number.", 400
       except Exception as e:
           flash(str(e))
           return "Error processing checkout: " + str(e), 400
   else:
       flash("Guest ID is required.")
       return "Guest ID is required.", 400

if __name__ == '__main__':
    app.run()
