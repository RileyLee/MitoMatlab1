matName = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\Features\SampleII2\DNN10FeatsTrain.mat';
arffName = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\Features\SampleII2\DNN10FeatsTrain.arff';


javaaddpath('E:\LeeYuguang\MitosisExtraction\Tasks\AutoParameterTest\matlab2weka\matlab2weka\matlab2weka.jar')
javaaddpath('C:\Program Files\Weka-3-6\weka.jar');
import matlab2weka.*;
import weka.classifiers.meta.CostSensitiveClassifier.*;
import weka.classifiers.CostMatrix.*;



load(matName);

featName = cell(1,100);  %Title = cell(1,201);
for i = 1:100
    featName(i) = {['A',num2str(i)]};
end
classTrain = double(AllData(:,1)>0);
featTrain = AllData(:,2:101);

label = cell(length(classTrain),1);
label(find(classTrain==0)) = {'Non'};
label(find(classTrain==1)) = {'Mito'};
RFFconvert2wekaObj = convert2weka('training', featName, featTrain', label, true); 
ft_train_weka = convert2wekaObj.getInstances();
clear convert2wekaObj;

saveARFF(arffName,ft_train_weka);