# Additional D3 homework

# load input.csv into a variable `rows`
import csv
import datetime

with open('input.csv') as f:
    reader = csv.DictReader(f)
    rows = list(reader)
    for row in rows:
        row['modeldate'] = datetime.datetime.strptime(row['modeldate'], "%m/%d/%Y")


# Sorting by datec 
rows = sorted(rows, key=lambda x: x['modeldate'])


# loop through the rows and output a csv with the date and 6 different series:

with open('output.csv', 'w') as f:
    writer = csv.writer(f)
    writer.writerow(['year','variableA','variableB','variableC','variableD', 'variableE', 'variableF'])

    for row in rows:
        writer.writerow([
            row['modeldate'].strftime("%Y-%m-%d"),
            row['approve_estimate'],
            row['disapprove_estimate'],
            row['approve_hi'],
            row['approve_lo'],
            row['disapprove_hi'],
            row['disapprove_lo']
        ])