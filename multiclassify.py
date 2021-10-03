from sklearn.datasets import load_iris
import xgboost as xgb
from xgboost import plot_importance
from matplotlib import pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.metrics import precision_score
from sklearn.metrics import confusion_matrix,classification_report
import pandas as pd
from sklearn.model_selection import StratifiedShuffleSplit
from sklearn.model_selection import GridSearchCV
from sklearn.svm import LinearSVC
from sklearn.preprocessing import StandardScaler,RobustScaler,MinMaxScaler



ss = MinMaxScaler()



#加载样本数据集 列名是特征 行名是标签
data=pd.read_csv("featurematrix2.csv",header=0)
print(data["label"])

y=data.iloc[:,0]
X=data.iloc[:,1:]



#size=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]
size2=[0.25,0.3,0.35,0.4]
for i in size2:
    split = StratifiedShuffleSplit(n_splits=10, test_size=i, random_state=6)

    #进行分层采样
    for train_index, test_index in split.split(data, data["label"]):
        train_set = data.iloc[train_index, :]
        test_set = data.iloc[test_index, :]
    X_train=train_set.iloc[:,1:]
    X_test=test_set.iloc[:,1:]
    y_train=train_set[['label']]
    y_test=test_set[['label']]
    y_train.to_csv("y_train.csv")

    # 训练模型
    model = xgb.XGBClassifier(max_depth=10, min_child_weight=4,learning_rate=0.1, n_estimators=200, objective='multi:softmax',gamma=1e-5)



    X_train = ss.fit_transform(X_train)
    X_test = ss.transform(X_test)
    model.fit(X_train, y_train)

    # 对测试集进行预测
    y_pred = model.predict(X_test)

    # 计算准确率
    accuracy = accuracy_score(y_test, y_pred)
    precision = precision_score(y_test, y_pred,average='micro')
    precision_weighted = precision_score(y_test, y_pred,average='weighted')


    print('accuracy:%2.f%%' % (accuracy * 100))
    print('precision:%2.f%%' % (precision * 100))
    print('precision-WEIGHTED:%2.f%%' % (precision_weighted * 100))

    print(confusion_matrix(y_test, y_pred))
    print(classification_report(y_test, y_pred,digits=2))

    # 显示重要特征
    plot_importance(model)
    plt.show()


# #测试其他模型
# from sklearn.linear_model import LogisticRegression
# from sklearn.ensemble import RandomForestClassifier
# from sklearn.naive_bayes import MultinomialNB
# from sklearn.svm import LinearSVC
# model2 =RandomForestClassifier()
#
# model2.fit(X_train, y_train)
# y_pred2 = model2.predict(X_test)
# print(classification_report(y_test, y_pred2,digits=2))
