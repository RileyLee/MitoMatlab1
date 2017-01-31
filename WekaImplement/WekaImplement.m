clear all
clc

ModelPath = 'E:\LeeYuguang\MitosisExtraction\Tasks\WekaImpleExp_1001\';
javaaddpath('C:\Program Files\Weka-3-6\weka.jar');
addpath('E:\LeeYuguang\MitosisExtraction\PreliminaryResults\Morpho_ICPR\Progress\Sep18_Morphefeats\matlab2weka');




import weka.classifiers.Classifier
import weka.classifiers.bayes.BayesNet
import weka.classifiers.Evaluation
import weka.core.SerializationHelper.read

% Classifier cls;
cls = weka.core.SerializationHelper.read([ModelPath,'RF100.model']);

TestData = ReadCSV2WekaOBJ('E:\LeeYuguang\MitosisExtraction\Tasks\WekaImpleExp_1001\TestWeka.csv', 'AllFeats');
% ReadMat2WekaOBJ();

[Pred,Scores] = wekaClassify(TestData, cls);

Scores = 1 - Scores;
Scores = [[1:length(Scores)]',Scores];

save([ModelPath,'Prediction.mat'],'Scores');

%%Change the format of the csv file