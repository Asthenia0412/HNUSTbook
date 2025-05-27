import numpy as np
import matplotlib.pyplot as plt

# 输入数据1行2列，这里只有张三的数据
X = np.array([[1,0.1]])
# X = np.array([[1,0.1],
#               [0.1,1],
#               [0.1,0.1],
#               [1,1]])
# 标签，也叫真值，1行1列，张三的真值：一定录用
T = np.array([[1]])
# T = np.array([[1],
#               [0],
#               [0],
#               [1]])

# 定义一个2隐层的神经网络：2-2-2-1
# 输入层2个神经元，隐藏1层2个神经元，隐藏2层2个神经元，输出层1个神经元

# 输入层到隐藏层1的权值初始化，2行2列
W1 = np.array([[0.8,0.2],
              [0.2,0.8]])
# 隐藏层1到隐藏层2的权值初始化，2行2列
W2 = np.array([[0.5,0.0],
              [0.5,1.0]])
# 隐藏层2到输出层的权值初始化，2行1列
W3 = np.array([[0.5],
              [0.5]])


# 初始化偏置值
# 隐藏层1的2个神经元偏置
b1 = np.array([[-1,0.3]])
# 隐藏层2的2个神经元偏置
b2 = np.array([[0.1,-0.1]])
# 输出层的1个神经元偏置
b3 = np.array([[-0.6]])
# 学习率设置
lr = 0.1
# 定义训练周期数10000
epochs = 10000
# 每训练1000次计算一次loss值  # 定义测试周期数
report = 1000
# 将所有样本分组，每组大小为
batch_size = 1

# 定义sigmoid函数
def sigmoid(x):
    return 1/(1+np.exp(-x))

# 定义sigmoid函数导数
def dsigmoid(x):
    return x*(1-x)

# 更新权值和偏置值
def update():
    global batch_X,batch_T,W1,W2,W3,lr,b1,b2,b3
    
    # 隐藏层1输出
    Z1 = np.dot(batch_X,W1) + b1    
    A1 = sigmoid(Z1)

    # 隐藏层2输出
    Z2 = (np.dot(A1,W2) + b2)
    A2 = sigmoid(Z2)
    
    # 输出层输出
    Z3=(np.dot(A2,W3) + b3)
    A3 = sigmoid(Z3)
    
    # 求输出层的误差
    delta_A3 = (batch_T - A3)
    delta_Z3 = delta_A3 * dsigmoid(A3)
    
    # 利用输出层的误差，求出三个偏导（即隐藏层2到输出层的权值改变）    # 由于一次计算了多个样本，所以需要求平均
    delta_W3 = A2.T.dot(delta_Z3) / batch_X.shape[0]
    delta_B3 = np.sum(delta_Z3, axis=0) / batch_X.shape[0]
    
    # 求隐藏层2的误差
    delta_A2 = delta_Z3.dot(W3.T)
    delta_Z2 = delta_A2 * dsigmoid(A2)
    
    # 利用隐藏层2的误差，求出三个偏导（即隐藏层1到隐藏层2的权值改变）    # 由于一次计算了多个样本，所以需要求平均
    delta_W2 = A1.T.dot(delta_Z2) / batch_X.shape[0]
    delta_B2 = np.sum(delta_Z2, axis=0) / batch_X.shape[0]
    
    # 求隐藏层1的误差
    delta_A1 = delta_Z2.dot(W2.T)
    delta_Z1 = delta_A1 * dsigmoid(A1)
    
    # 利用隐藏层1的误差，求出三个偏导（即输入层到隐藏层1的权值改变）    # 由于一次计算了多个样本，所以需要求平均
    delta_W1 = batch_X.T.dot(delta_Z1) / batch_X.shape[0]
    delta_B1 = np.sum(delta_Z1, axis=0) / batch_X.shape[0]
    
    # 更新权值
    W3 = W3 + lr *delta_W3
    W2 = W2 + lr *delta_W2
    W1 = W1 + lr *delta_W1
    
    # 改变偏置值
    b3 = b3 + lr * delta_B3
    b2 = b2 + lr * delta_B2
    b1 = b1 + lr * delta_B1

# 定义空list用于保存loss
loss = []
batch_X = []
batch_T = []
max_batch = X.shape[0] // batch_size
# 训练模型
for idx_epoch in range(epochs):
    
    for idx_batch in range(max_batch):
        # 更新权值
        batch_X = X[idx_batch*batch_size:(idx_batch+1)*batch_size, :]
        batch_T = T[idx_batch*batch_size:(idx_batch+1)*batch_size, :]
        update()
    # 每训练5000次计算一次loss值
    if idx_epoch % report == 0:
        # 隐藏层1输出
        A1 = sigmoid(np.dot(X,W1) + b1)
        # 隐藏层2输出
        A2 = sigmoid(np.dot(A1,W2) + b2)
        # 输出层输出
        A3 = sigmoid(np.dot(A2,W3) + b3)
        # 计算loss值
        print('A3:',A3)
        print('epochs:',idx_epoch,'loss:',np.mean(np.square(T - A3) / 2))
        # 保存loss值
        loss.append(np.mean(np.square(T - A3) / 2))

# 画图训练周期数与loss的关系图
plt.plot(range(0,epochs,report),loss)
plt.xlabel('epochs')
plt.ylabel('loss')
plt.show()
        
# 隐藏层1输出
A1 = sigmoid(np.dot(X,W1) + b1)
# 隐藏层2输出
A2 = sigmoid(np.dot(A1,W2) + b2)
# 输出层输出
A3 = sigmoid(np.dot(A2,W3) + b3)
print('output:')
print(A3)

# 因为最终的分类只有0和1，所以我们可以把
# 大于等于0.5的值归为1类，小于0.5的值归为0类
def predict(x):
    if x>=0.5:
        return 1
    else:
        return 0

# map会根据提供的函数对指定序列做映射
# 相当于依次把A3中的值放到predict函数中计算
# 然后打印出结果
print('predict:')
for i in map(predict,A3):
    print(i)


