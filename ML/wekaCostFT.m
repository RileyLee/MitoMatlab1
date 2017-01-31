function classifier = wekaCostRF(featTrain, classTrain, featName, costMatrix)

%javaaddpath('E:\LeeYuguang\MitosisExtraction\Tasks\AutoParameterTest\matlab2weka\matlab2weka\matlab2weka.jar')
%javaaddpath('C:\Program Files\Weka-3-6\weka.jar');

import matlab2weka.*;
import weka.classifiers.meta.CostSensitiveClassifier.*;
import weka.classifiers.CostMatrix.*;

%% Converting to WEKA data  
display('Converting Data into WEKA format...');

%convert the testing data to an Weka object
label = cell(length(classTrain),1);
label(find(classTrain==0)) = {'Non'};
label(find(classTrain==1)) = {'Mito'};
convert2wekaObj = convert2weka('training', featName, featTrain', label, true); 
ft_train_weka = convert2wekaObj.getInstances();
clear convert2wekaObj;

%% Choosing the Classifier
display('Random Forest training...');
import weka.classifiers.trees.RandomForest.*;
import weka.classifiers.meta.Bagging.*;
%create an java object
trainModel = weka.classifiers.trees.FT();
% trainModel.set
%train the classifier
trainModel.buildClassifier(ft_train_weka);   
%trainModel.toString()  

%% initializing the meta (cost sensitive) classifier

%creating a cost function
if (ft_train_weka.numClasses() ~= size(costMatrix,1))
    warning('The size of the cost matrix does not match the number of classes in the training data');
    return;
end
costMatrix_weka = weka.classifiers.CostMatrix(size(costMatrix,1));
for irow = 1:size(costMatrix,1)
    for icol = 1:size(costMatrix,2)
        costMatrix_weka.setElement(irow-1, icol-1, costMatrix(irow,icol));
    end
end

% initializing the meta (cost sensitive) classifier
metaClassifier = weka.classifiers.meta.CostSensitiveClassifier();
metaClassifier.setMinimizeExpectedCost(false);
metaClassifier.setCostMatrix(costMatrix_weka);
metaClassifier.setClassifier(trainModel);
metaClassifier.buildClassifier(ft_train_weka);
  
classifier = metaClassifier;