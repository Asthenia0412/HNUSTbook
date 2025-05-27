import numpy as np
import matplotlib.pyplot as plt


def fun(x):
    return x * np.sin(10*np.pi*x) + 2


Xs = np.linspace(-1, 2, 100)

np.random.seed(0)  # 令随机数种子=0，确保每次取得相同的随机数

# 初始化原始种群
population = np.random.uniform(-1, 2, 10)  # 在[-1,2)上以均匀分布生成10个浮点数，做为初始种群

for pop, fit in zip(population, fun(population)):
    print("x=%5.2f, fit=%.2f" % (pop, fit))

plt.plot(Xs, fun(Xs))
plt.plot(population, fun(population), '*')
plt.show()


def encode(population, _min=-1, _max=2, scale=2**18, binary_len=18):  # population必须为float类型，否则精度不能保证
    # 标准化，使所有数据位于0和1之间,乘以scale使得数据间距拉大以便用二进制表示
    normalized_data = (population-_min) / (_max-_min) * scale
    # 转成二进制编码
    binary_data = np.array([np.binary_repr(x, width=binary_len)
                           for x in normalized_data.astype(int)])
    return binary_data


chroms = encode(population)  # 染色体英文(chromosome)


for pop, chrom, fit in zip(population, chroms, fun(population)):
    print("x=%.2f, chrom=%s, fit=%.2f" % (pop, chrom, fit))


def decode(popular_gene, _min=-1, _max=2, scale=2**18):  # 先把x从2进制转换为10进制，表示这是第几份
    # 乘以每份长度（长度/份数）,加上起点,最终将一个2进制数，转换为x轴坐标
    return np.array([(int(x, base=2)/scale*3)+_min for x in popular_gene])



fitness = fun(decode(chroms))

for pop, chrom, dechrom, fit in zip(population, chroms, decode(chroms), fitness):
    print("x=%5.2f, chrom=%s, dechrom=%.2f, fit=%.2f" %
          (pop, chrom, dechrom, fit))

fitness = fitness - fitness.min() + 0.000001  # 保证所有的都为正
print(fitness)


def Select_Crossover(chroms, fitness, prob=0.6):  # 选择和交叉
    probs = fitness/np.sum(fitness)  # 各个个体被选择的概率
    probs_cum = np.cumsum(probs)  # 概率累加分布

    each_rand = np.random.uniform(size=len(fitness))  # 得到10个随机数，0到1之间

    # 轮盘赌，根据随机概率选择出新的基因编码
    # 对于each_rand中的每个随机数，找到被轮盘赌中的那个染色体
    newX = np.array([chroms[np.where(probs_cum > rand)[0][0]]
                    for rand in each_rand])

    # 繁殖，随机配对（概率为0.6)
    # 6这个数字怎么来的，根据遗传算法，假设有10个数，交叉概率为0.6，0和1一组，2和3一组。。。8和9一组，每组扔一个0到1之间的数字
    # 这个数字小于0.6就交叉，则平均下来应有三组进行交叉，即6个染色体要进行交叉
    pairs = np.random.permutation(
        int(len(newX)*prob//2*2)).reshape(-1, 2)  # 产生6个随机数，乱排一下，分成二列
    center = len(newX[0])//2  # 交叉方法采用最简单的，中心交叉法
    for i, j in pairs:
        # 在中间位置交叉
        x, y = newX[i], newX[j]
        newX[i] = x[:center] + y[center:]  # newX的元素都是字符串，可以直接用+号拼接
        newX[j] = y[:center] + x[center:]
    return newX


chroms = Select_Crossover(chroms, fitness)

dechroms = decode(chroms)
fitness = fun(dechroms)

for gene, dec, fit in zip(chroms, dechroms, fitness):
    print("chrom=%s, dec=%5.2f, fit=%.2f" % (gene, dec, fit))

# 对比一下选择和交叉之后的结果
fig, (axs1, axs2) = plt.subplots(1, 2, figsize=(14, 5))
axs1.plot(Xs, fun(Xs))
axs1.plot(population, fun(population), 'o')
axs2.plot(Xs, fun(Xs))
axs2.plot(dechroms, fitness, '*')
plt.show()

# 输入一个原始种群1，输出一个变异种群2  函数参数中的冒号是参数的类型建议符，告诉程序员希望传入的实参的类型。函数后面跟着的箭头是函数返回值的类型建议符，用来说明该函数返回的值是什么类型。


def Mutate(chroms: np.array):
    prob = 0.1  # 变异的概率
    clen = len(chroms[0])  # chroms[0]="111101101 000010110"    字符串的长度=18
    m = {'0': '1', '1': '0'}  # m是一个字典，包含两对：第一对0是key而1是value；第二对1是key而0是value
    newchroms = []  # 存放变异后的新种群
    each_prob = np.random.uniform(size=len(chroms))  # 随机10个数

    for i, chrom in enumerate(chroms):  # enumerate的作用是整一个i出来
        if each_prob[i] < prob:  # 如果要进行变异(i的用处在这里)
            pos = np.random.randint(clen)  # 从18个位置随机中找一个位置，假设是7
            # 0~6保持不变，8~17保持不变，仅将7号翻转，即0改为1，1改为0。注意chrom中字符不是1就是0
            chrom = chrom[:pos] + m[chrom[pos]] + chrom[pos+1:]
        newchroms.append(chrom)  # 无论if是否成立，都在newchroms中增加chroms的这个元素
    return np.array(newchroms)  # 返回变异后的种群


newchroms = Mutate(chroms)


def DrawTwoChroms(chroms1, chroms2, fitfun):  # 画2幅图，左边是旧种群，右边是新种群，观察平行的两幅图可以看出有没有差异
    Xs = np.linspace(-1, 2, 100)
    fig, (axs1, axs2) = plt.subplots(1, 2, figsize=(14, 5))
    dechroms = decode(chroms1)
    fitness = fitfun(dechroms)
    axs1.plot(Xs, fitfun(Xs))
    axs1.plot(dechroms, fitness, 'o')

    dechroms = decode(chroms2)
    fitness = fitfun(dechroms)
    axs2.plot(Xs, fitfun(Xs))
    axs2.plot(dechroms, fitness, '*')
    plt.show()


# 对比一下变异前后的结果
DrawTwoChroms(chroms, newchroms, fun)

# 上述代码只是执行了一轮，这里反复迭代
np.random.seed(0)  # 
population = np.random.uniform(-1, 2, 100)  # 这次多找一些点
chroms = encode(population)

for i in range(1000):
    fitness = fun(decode(chroms))
    fitness = fitness - fitness.min() + 0.000001  # 保证所有的都为正
    newchroms = Mutate(Select_Crossover(chroms, fitness))
    if i % 300 == 1:
        DrawTwoChroms(chroms, newchroms, fun)
    chroms = newchroms

DrawTwoChroms(chroms, newchroms, fun)
