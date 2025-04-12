import numpy as np
arr = np.random.rand(2,3,4)
print(arr.shape)

t = np.transpose(arr,(1,0,2))
print(t.shape)