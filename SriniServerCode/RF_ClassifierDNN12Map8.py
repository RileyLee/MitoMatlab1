import scipy.io as sio
import sklearn
import numpy as np
from sklearn.ensemble import RandomForestClassifier

 

def Accuracy(Label,Pred):
    Pos = np.where(Label!=0)
    Pos = Pos[0]
    Neg = np.where(Label!=1)
    Neg = Neg[0]
    Mat = np.zeros((2,2),dtype=np.int)
    Mat[0][0] = sum(Pred[Pos])
    Mat[0][1] = len(Pos) - Mat[0][0]
    Mat[1][0] = sum(Pred[Neg])
    Prec = np.double(Mat[0][0]) / np.double((Mat[0][0] + Mat[1][0]))
    Recall = np.double(Mat[0][0]) / np.double((Mat[0][0] + Mat[0][1]))
    F = Prec * Recall / (Prec + Recall) *2   
    return (Mat,F,Prec,Recall)


def Accuracy8(Label,Pred):
    Pos = np.where(Label!=0)
    Pos = Pos[0]
    Neg = np.where(Label!=1)
    Neg = Neg[0]
    Mat = np.zeros((2,2),dtype=np.int)
    Mat[0][0] = sum(Pred[Pos]>=0.80)
    Mat[0][1] = len(Pos) - Mat[0][0]
    Mat[1][0] = sum(Pred[Neg]>=0.80)
    Prec = np.double(Mat[0][0]) / np.double((Mat[0][0] + Mat[1][0]))
    Recall = np.double(Mat[0][0]) / np.double((Mat[0][0] + Mat[0][1]))
    F = Prec * Recall / (Prec + Recall) *2   
    return (Mat,F,Prec,Recall)


def DisplayScore(Mat,F,Prec,Recall):
    print "Confusion Matrix:"
    print Mat
    print 'Precision:' + str(Prec) 
    print 'Recall:' + str(Recall) 
    print 'F Score:' + str(F)



featPath = '/home/ylee3/Mitosis/ClassifierEnsemble/DNN_Features/DNN12FeatsTrain.mat';
testPath = '/home/ylee3/Mitosis/ClassifierEnsemble/DNN_Features/DNN12_Test.mat';


testFeats = sio.loadmat(testPath);


testLabel = testFeats['testLabel']
testFeats = testFeats['Data']

Feats = sio.loadmat(featPath);
Feats = Feats['AllData'];

Label = Feats[:,0]
Score = Feats[:,101]
Feats = Feats[:,1:101]

clf = RandomForestClassifier(n_estimators = 10, max_depth = None)
clf = clf.fit(Feats,Label)


Pred = np.zeros(len(testFeats),dtype=np.float)

for i in range(0,8):
    testFeatsLoc = testFeats[0][i];
    testFeatsLoc = testFeatsLoc[:,2:102];
    PredTemp = clf.predict_proba(testFeatsLoc)
    Pred = Pred + PredTemp[:,1] 


Pred = Pred / 8;

Mat,F,Prec,Recall = Accuracy8(testLabel,Pred)
DisplayScore(Mat,F,Prec,Recall)

