import scipy.io as sio
import sklearn
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC
from sklearn.externals import joblib

 
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
    Mat[0][0] = sum(Pred[Pos]>=0.8)
    Mat[0][1] = len(Pos) - Mat[0][0]
    Mat[1][0] = sum(Pred[Neg]>=0.8)
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

#np.random.seed(seed = 1000)

featPathDNN12 = '/home/ylee3/Mitosis/ClassifierEnsemble/DNN_Features/DNN12FeatsTrain.mat';
testDNN12Path = '/home/ylee3/Mitosis/ClassifierEnsemble/DNN_Features/DNN12_Test.mat';

testFeatsDNN12 = sio.loadmat(testDNN12Path);

testLabelDNN12 = testFeatsDNN12['testLabel']
testFeatsDNN12 = testFeatsDNN12['Data']

FeatsDNN12 = sio.loadmat(featPathDNN12);
FeatsDNN12 = FeatsDNN12['AllData'];

LabelDNN12 = FeatsDNN12[:,0]
ScoreDNN12 = FeatsDNN12[:,101]
FeatsDNN12 = FeatsDNN12[:,1:101]





featPathDNN10 = '/home/ylee3/Mitosis/ClassifierEnsemble/DNN_Features/DNN10FeatsTrain.mat';
testDNN10Path = '/home/ylee3/Mitosis/ClassifierEnsemble/DNN_Features/DNN10_Test.mat';

print "Loading Data.."

testFeatsDNN10 = sio.loadmat(testDNN10Path);

testLabel = testFeatsDNN10['testLabel']
testFeatsDNN10 = testFeatsDNN10['Data']

FeatsDNN10 = sio.loadmat(featPathDNN10);
FeatsDNN10 = FeatsDNN10['AllData'];

Label = FeatsDNN10[:,0]
ScoreDNN10 = FeatsDNN10[:,101]
FeatsDNN10 = FeatsDNN10[:,1:101]


Feats = np.hstack((FeatsDNN10, FeatsDNN12))
    

testFeats = np.hstack((testFeatsDNN10[:,2:102], testFeatsDNN12[:,2:102]))

print "Fitting Random Forest Model.."

#clf = RandomForestClassifier(n_estimators = 5, max_depth = None)
#clf = clf.fit(Feats,Label)
#np.random.seed(seed = 1000)
clf = RandomForestClassifier(n_estimators = 100, max_depth = None)
#clf = SVC();
clf = clf.fit(Feats,Label)


print "Assessing Accuracy.."

Pred = np.zeros(len(testFeatsDNN10[0][0]),dtype=np.float)

for i in range(0,8):
    temp1 = testFeatsDNN10[0][i];
    temp2 = testFeatsDNN12[0][i] 
    testFeatsLoc = np.hstack((temp1[:,2:102],temp2[:,2:102]));
    PredTemp = clf.predict_proba(testFeatsLoc )
    Pred = Pred + PredTemp[:,1] 


Pred = Pred / 8;

Mat,F,Prec,Recall = Accuracy8(testLabel,Pred)
DisplayScore(Mat,F,Prec,Recall)

joblib.dump(clf,'clf_DNNBothRF.pkl')

