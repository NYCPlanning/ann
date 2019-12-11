import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from IPython import get_ipython
get_ipython().run_line_magic('matplotlib', 'inline')

df = pd.read_csv("../data/numfloors.csv")

df.head()

df.boxplot(by="Borough", column=['NumFloors'])
