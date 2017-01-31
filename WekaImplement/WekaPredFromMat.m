clear all
clc

ModelPath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\Morpho_ICPR\HCFeats\HC20_Sample0918_SE5\WekaModel\RF100\';
javaaddpath('C:\Program Files\Weka-3-6\weka.jar');
addpath('E:\LeeYuguang\MitosisExtraction\PreliminaryResults\Morpho_ICPR\Progress\Sep18_Morphefeats\matlab2weka');
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ReadData\ICPR\')
FeatPath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\Morpho_ICPR\HCFeats\HC20_Sample0918_SE5\HC20_Sample0918_Feats\';
LabelPath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\Morpho_ICPR\HCFeats\HC20_Sample0918_SE5\HC20_Sample0918_Label\';
TitleCSV = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\Morpho_ICPR\HCFeats\HC20_Sample0918_SE5\Title.csv';

import weka.classifiers.Classifier
import weka.classifiers.bayes.BayesNet
import weka.classifiers.Evaluation
import weka.core.SerializationHelper.read

% Classifier cls;
cls = weka.core.SerializationHelper.read([ModelPath,'RF100.model']);

Scores = [];
for File = 1:100
%     clc
    disp(['Processing File ',ICPR_FileNameGenerate(File-1),' ...']);
%     disp('Reading Weka Object...');
    FileName = [ICPR_FileNameGenerate(File-1),'.mat'];
    [TestData, Labels] = ReadMat2WekaOBJ([FeatPath,FileName], [LabelPath,FileName], TitleCSV);
%     disp(['Classifying File ',ICPR_FileNameGenerate(File-1),' ...'])
    [Score,A] = wekaClassify(TestData, cls);
    Scores = [Scores;[File*ones(length(Labels),1),cell2mat(Labels(:,1)),Score]];
end


Scores = [[1:length(Scores)]',Scores];

