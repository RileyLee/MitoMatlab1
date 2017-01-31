javaaddpath('C:\Program Files\Weka-3-6\weka.jar');
addpath('E:\LeeYuguang\MitosisExtraction\PreliminaryResults\Morpho_ICPR\Progress\Sep18_Morphefeats\matlab2weka');

clear all
clc

import weka.classifiers.Classifier
import weka.classifiers.bayes.BayesNet
import weka.classifiers.Evaluation
import weka.core.SerializationHelper.read

% Classifier cls;
cls = weka.core.SerializationHelper.read('E:\LeeYuguang\MitosisExtraction\PreliminaryResults\Morpho_ICPR\Progress\Sep18_Morphefeats\WekaModel\RF500.model');

TestData = ReadCSV2WekaOBJ('TestFeats1.csv', 'TestFeats');
sum(wekaClassify(TestData, cls))

