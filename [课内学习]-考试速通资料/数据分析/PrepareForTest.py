import pandas as pd
import numpy as np
np.random.seed(0x1010)
t = np.random.normal(75,8,160).reshape(40,4)
t = t.astype(int)
df = pd.DataFrame(t,index=range(1001,1041),columns=['A','B','C','D'])
print(df.head(5))