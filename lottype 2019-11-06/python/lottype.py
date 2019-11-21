#
# This is the script I used to identify lottype combinations we're getting from CAMA.
#

import csv
import os

print('Starting Module...')

script_dir = os.path.dirname(__file__)  # Script directory
cama_full_path = os.path.join(script_dir, '../data/cama_lottypes.csv')
combos_full_path = os.path.join(script_dir, '../data/lottype_combos.csv')

with open(cama_full_path) as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    next(csv_reader)
    line_count = read_count = write_count = multi_lottype_count = 0
    bbl = ''

    with open(combos_full_path, mode='w', newline='') as lottype_combos_file:
        lottype_combos_writer = csv.writer(lottype_combos_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        for row in csv_reader:
            read_count = read_count + 1
            if read_count == 1:
                bbl = row[0]
                lottypes = []

            if bbl == row[0]:
                # you've got more than one lottype. append it to the previously created list
                lottypes.append(row[1])
            else:
                # you've hit another bbl. write out the previous record and initialize the lottype list for the new bbl.
                if len(lottypes) > 1:
                    multi_lottype_count = multi_lottype_count + 1
                lottype_combos_writer.writerow([bbl, lottypes])
                write_count = write_count + 1
                lottypes = []
                lottypes.append(row[1])
                bbl = row[0]

            csv_reader = csv.reader(csv_file, delimiter=',')

print('Module ended.')
print('Processed ' + str(read_count))
print('Wrote ' + str(write_count))
print('Number of BINs with multiple lot types: ' + str(multi_lottype_count))
