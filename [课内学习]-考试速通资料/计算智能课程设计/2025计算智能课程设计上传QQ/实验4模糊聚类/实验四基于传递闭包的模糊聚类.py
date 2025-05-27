import numpy as np

np.set_printoptions(precision=2)  # 设置矩阵输出精度,保留两位小数

def MaxNormalization(a):
    """
    采用最大值规格化法将数据规格化为
    """
    c = np.zeros_like(a, dtype=float)
    for j in range(c.shape[1]):  # 遍历c的列
        for i in range(c.shape[0]):  # 遍历c的列
            c[i, j] = a[i, j]/np.max(a[:, j])
    return c

def FuzzySimilarMatrix(a):
    """
    用最大最小法构造得到模糊相似矩阵
    """
    a = MaxNormalization(a)  # 用标准化后的数据
    c = np.zeros((a.shape[0], a.shape[0]), dtype=float)
    mmax = []
    mmin = []
    for i in range(c.shape[0]):  # 遍历c的行
        for j in range(c.shape[0]):  # 遍历c的行
            mmax.extend([np.fmax(a[i, :], a[j, :])])  # 取i和和j行的最大值,即求i行和j行的并
            mmin.extend([np.fmin(a[i, :], a[j, :])])  # 取i和和j行的最大值,即求i行和j行的交
    for i in range(len(mmax)):
        mmax[i] = np.sum(mmax[i])  # 求并的和
        mmin[i] = np.sum(mmin[i])  # 求交的和
    mmax = np.array(mmax).reshape(c.shape[0], c.shape[1])  # 变换为与c同型的矩阵
    mmin = np.array(mmin).reshape(c.shape[0], c.shape[1])  # 变换为与c同型的矩阵
    for i in range(c.shape[0]):  # 遍历c的行
        for j in range(c.shape[1]):  # 遍历c的列
            c[i, j] = mmin[i, j]/mmax[i, j]  # 赋值相似度
    return c

def MatrixComposition(a, b):
    """
    合成模糊矩阵a和模糊矩阵b
    """
    a, b = np.array(a), np.array(b)
    c = np.zeros_like(a.dot(b))
    for i in range(a.shape[0]):  # 遍历a的行元素
        for j in range(b.shape[1]):  # 遍历b的列元素
            empty = []
            for k in range(a.shape[1]):
                empty.append(min(a[i, k], b[k, j]))  # 行列元素比小
            c[i, j] = max(empty)  # 比小结果取大
    return c

def TransitiveClosure(a):
    """
    平方法合成传递闭包
    """
    a = FuzzySimilarMatrix(a)  # 用模糊相似矩阵
    c = a
    while True:
        m = c
        c = MatrixComposition(MatrixComposition(a, c), MatrixComposition(a, c))
        if (c == m).all():  # 闭包条件
            return np.around(c, decimals=2)  # 返回传递闭包,四舍五入,保留两位小数
            break
        else:
            continue

def CutSet(a):
    """
    水平截集
    """
    a = TransitiveClosure(a)  # 用传递闭包

    return np.sort(np.unique(a).reshape(-1))[::-1]

def get_classes(temp_pairs):
    lists = []

    for item1 in temp_pairs:
        temp_list = []
        for item2 in temp_pairs:
            if item1[0] == item2[1]:
                temp_list.append(item2[0])
        lists.append(list(set(temp_list)))

    return(list(np.unique(lists)))

def Result(a):
    """
    模糊聚类结果
    """
    lambdas = CutSet(a)
    a = TransitiveClosure(a)

    classes = []

    for lam in lambdas:
        if lam == lambdas[0]:
            classes.append([[a] for a in range(len(a))])
        else:
            pairs = np.argwhere(a >= lam)
            classes.append(get_classes(pairs))
    return classes

def main():
    """
    特性指标矩阵
    """
    input = np.array([[17, 15, 14, 15, 16],
                      [18, 16, 13, 14, 12],
                      [18, 18, 19, 17, 18],
                      [16, 18, 16, 15, 18]], dtype=object)

    print("特性指标矩阵\n", input)
    print("\n采用最大值规格化法将数据规格化为\n", MaxNormalization(input))
    print("\n用最大最小法构造得到模糊相似矩阵\n", FuzzySimilarMatrix(input))
    print("\n平方法合成传递闭包\n", TransitiveClosure(input))
    print("\n水平截集为\n", CutSet(input))
    print("\n模糊聚类结果\n", Result(input))


if __name__ == "__main__":
    main()
