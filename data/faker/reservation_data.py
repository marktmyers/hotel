"""Generate fake data for the hotel database."""

from faker import Faker
import random
import datetime
import csv

fake = Faker()

days_in_month = {
    1: 31,  # January
    2: 28,  # February
    3: 31,  # March
    4: 30,  # April
    5: 31,  # May
    6: 30,  # June
    7: 31,  # July
    8: 31,  # August
    9: 30,  # September
    10: 31,  # October
    11: 30,  # November
    12: 31   # December
}

'''I got rid of room ID and put in hotel id, so might have to add that back.
    Also i only have 20 reservations rn and its gonna have to be 2000 bc 100 reservations
    per 1 hotel x 20 hotels. Class notes should help me put this data into DB.'''
def make_reservations():
    reservations = []
    for id in range(1, 2001): #2001
        r = []
        r.append(id)                        # booking ID
        r.append(random.randint(1, 20))     # hotel ID
        r.append(random.randint(1, 200))    # guest ID

        if id % 2 == 0:
            start = datetime.datetime(2010, 1, 1)
            end = datetime.datetime(2019, 12, 31)
            book_date = fake.date_between(start, end)
        else:
            start = datetime.datetime(2020, 1, 1)
            end = datetime.datetime(2024, 4, 1)
            book_date = fake.date_between(start, end)
        r.append(book_date)                 # booking date
        start_date = make_start_date(id, book_date)
        r.append(start_date)                # start date

        end_date = make_end_date(start_date)
        r.append(end_date)                  # end date
        typename = make_types()
        r.append(typename)                  # room type
        reservations.append(r)
    return reservations


def make_start_date(id, book_date):

    if id % 2 == 0:
        past_end = datetime.datetime(2024, 3, 31)
        start_date = fake.date_between(book_date, past_end)
    else:
        future_start = datetime.datetime(2024, 4, 1)
        future_end = datetime.datetime(2030, 1, 1)
        start_date = fake.date_between(future_start, future_end)

    return start_date


def make_end_date(start_date):
    days_stayed = random.randint(1, 21)
    current_year = start_date.year
    current_month = start_date.month
    current_day = start_date.day

    if current_day + days_stayed > days_in_month.get(current_month):
        days_overflow = current_day + days_stayed - days_in_month.get(current_month)

        if current_month != 12:
            month = current_month + 1
            year = current_year
        else:
            month = 1
            year = current_year + 1
    else:
        days_overflow = current_day + days_stayed # no overflow
        month = current_month
        year = current_year

    end_date = datetime.date(year, month, days_overflow)
    return end_date

def make_types():
    types = {
        1: "Smoking Single",
        2: "Penthouse",
        3: "Family Style",
        4: "Suite",
        5: "Smoking Double",
        6: "King",
        7: "Single",
        8: "Double"}
    type = types.get(random.randint(1,8))

    return type

if __name__ == "__main__":
    rez = make_reservations()
    with open('reservations.tsv', 'w', newline='') as file:
        writer = csv.writer(file, delimiter='\t')
        # writer.writerow(["Booking ID", "Hotel ID", "Guest ID", "Booking Date", "Start Date", "End Date"])
        writer.writerows(rez)
