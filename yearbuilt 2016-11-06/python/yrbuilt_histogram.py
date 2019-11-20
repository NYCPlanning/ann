import os
import csv
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import rcParams
import seaborn as sns

sns.set(rc={'axes.facecolor':'#dddddd'})

SMALL_SIZE = 7
MEDIUM_SMALL_SIZE = 9
MEDIUM_SIZE = 11
BIGGER_SIZE = 16
rcParams['font.family'] = 'sans-serif'
rcParams['font.sans-serif'] = ['Inconsolata']
plt.rc('font', size=SMALL_SIZE)
plt.rc('axes', titlesize=BIGGER_SIZE)     # fontsize of the axes title
plt.rc('axes', labelsize=MEDIUM_SIZE)    # fontsize of the x and y labels
plt.rc('xtick', labelsize=MEDIUM_SMALL_SIZE)    # fontsize of the tick labels
plt.rc('ytick', labelsize=MEDIUM_SMALL_SIZE)    # fontsize of the tick labels
plt.rc('legend', fontsize=MEDIUM_SIZE)    # legend fontsize
plt.rc('figure', titlesize=BIGGER_SIZE)  # fontsize of the figure title

script_dir = os.path.dirname(__file__)  # Script directory
full_path = os.path.join(script_dir, '../data/decades.csv')

with open(full_path) as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    next(csv_reader)
    decade_hold = ''
    read_count = 0
    decades = []

    for row in csv_reader:
        read_count+=1
        decades.append(row[0])

df = pd.DataFrame({'Decade': decades})
df.groupby('Decade', as_index=False).size().plot(kind='bar', color="#b22148", width=1)
plt.xlabel('Decade', fontweight='bold', labelpad=10)
plt.ylabel('Frequency', fontweight='bold', labelpad=10)
plt.title('Year Built by Decade', fontweight='bold', pad=10)
plt.show()
