#
# Create a double bar chart of total lot areas by land use code.
#

import csv
import os
from matplotlib import rcParams
rcParams['font.family'] = 'sans-serif'
rcParams['font.sans-serif'] = ['Inconsolata']
import matplotlib.pyplot as plt
import numpy as np

SMALL_SIZE = 7
MEDIUM_SIZE = 11
BIGGER_SIZE = 14

plt.rc('font', size=SMALL_SIZE)
plt.rc('axes', titlesize=BIGGER_SIZE)     # fontsize of the axes title
plt.rc('axes', labelsize=MEDIUM_SIZE)    # fontsize of the x and y labels
plt.rc('xtick', labelsize=SMALL_SIZE)    # fontsize of the tick labels
plt.rc('ytick', labelsize=SMALL_SIZE)    # fontsize of the tick labels
plt.rc('legend', fontsize=MEDIUM_SIZE)    # legend fontsize
plt.rc('figure', titlesize=BIGGER_SIZE)  # fontsize of the figure title

print('Starting Module...')

script_dir = os.path.dirname(__file__)  # Script directory
full_path = os.path.join(script_dir, '../data/landuse.csv')

with open(full_path) as csv_file:
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
    ax.bar(r1, old_lotarea, width, color='#0080ff', align='center', label='Before Correction')
    ax.bar(r1+width, new_lotarea, width, color='#ff7e00', align='center', label='After Correction')
    ax.ticklabel_format(useOffset=False, style='plain')

    plt.xlabel('Land Use', fontweight='bold')
    plt.ylabel('Total Lot Area', fontweight='bold')
    plt.title('Lot Area by Land Use Code', fontweight='bold')
    plt.xticks(rotation=-20)
    plt.xticks(r1 + width / 2, landuse)
    plt.yticks(np.arange(100000000, 2000000000, 200000000))
    plt.legend(loc='best')
    plt.show()

print('Module ended.')
print('Processed ' + str(read_count))
