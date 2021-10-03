import pandas as pd
import numpy as np
def GSEandGPLtoUSEmatrix():
    matrix=pd.read_table("GSE6764_series_matrix.txt")
    matrix.index=matrix.iloc[:,0]

    GPL570=pd.read_table("GPL570.txt")
    gene=pd.read_csv("node.csv",header=None)
    genelist=gene.iloc[:,1]
    genelist=np.unique(genelist)

    print(matrix.head())
    # print(GPL570.head())
    # print(gene.head())
    print(genelist)
    print(len(genelist))

    useID=[]

    for i in range(0,len(GPL570["Gene Symbol"])):
        if GPL570.iloc[i,1] in genelist:
            useID.append(list(GPL570.iloc[i,]))

    useID=pd.DataFrame(useID)
    print(useID.iloc[:,0])

    hccmatrix=matrix.loc[np.unique(useID.iloc[:,0])]
    hccmatrix.insert(0,"GeneSymbol",list(useID.iloc[:,1]))
    hccmatrix=pd.DataFrame(hccmatrix)

    print(hccmatrix.head())
    hccmatrix.to_csv("hccmatrix2.csv")

#GSEandGPLtoUSEmatrix()
hccmatrix=pd.read_csv("hccmatrix2.csv")
hccmatrix.index=hccmatrix.iloc[:,0]
list=np.unique(hccmatrix["GeneSymbol"])
usegenelist=[i for i in list if i !='']
#print(usegenelist)
print(hccmatrix.loc["ABCB1"].mean())
usematrix=[]

for i in usegenelist:
    print(i)
    array=hccmatrix.loc[i]
    #print(array)
    dim=array.shape[0]
    print(dim)
    if dim!=76:
        #print("##########",array.mean())
        term=array.mean()
        usematrix.append(term)
        #print(usematrix)
    else:
        #print("!!!!!!!!!!!!!!!!",array)
        term2=array
        usematrix.append(term2)
usematrix=pd.DataFrame(usematrix)
usematrix.index=usegenelist
usematrix["GeneSymbol"]=usegenelist
print(usematrix)
usematrix.to_csv("usematrix2.csv")


