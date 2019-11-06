#
# Create a double bar chart of total lot areas by land use code.
#

import csv
import matplotlib.pyplot as plt
import numpy as np

print('Starting Module...')

with open('landuse.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    next(csv_reader)
    read_count = 0
    landuse = []
    lotarea = []
    old_lotarea = []
    new_lotarea = []

    for row in csv_reader:
        read_count = read_count + 1
        landuse.append(row[0])
        old_lotarea.append(int(row[1]))
        new_lotarea.append(int(row[2]))

    width = 0.4
    r1 = np.arange(len(landuse))

    ax = plt.subplot(111)
    ax.bar(r1, old_lotarea, width, color='#ff7e00', align='center', label='Before Correction')
    ax.bar(r1+width, new_lotarea, width, color='#0080ff', align='center', label='After Correction')
    ax.ticklabel_format(useOffset=False, style='plain')

    plt.xlabel('Land Use Code')
    plt.ylabel('Total Lot Area (in Billions of Sq. Ft.)')
    plt.title('Lot Area by Land Use Code')
    plt.xticks(r1 + width / 2, landuse)
    plt.yticks(np.arange(65000000, 2000000000, 50000000))
    plt.legend(loc='best')
    plt.show()

print('Module ended.')
print('Processed ' + str(read_count))
