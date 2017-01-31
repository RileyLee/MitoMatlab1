function prob = wekaClassifierEva(featTest, classTest, featName, classifier)

%javaaddpath('E:\LeeYuguang\MitosisExtraction\Tasks\AutoParameterTest\matlab2weka\matlab2weka\matlab2weka.jar')
%javaaddpath('C:\Program Files\Weka-3-6\weka.jar');

import matlab2weka.*;
import weka.classifiers.meta.CostSensitiveClassifier.*;
import weka.classifiers.CostMatrix.*;


label = cell(length(classTest),1);
label(find(classTest==0)) = {'Non'};
label(find(classTest==1)) = {'Mito'};
convert2wekaObj = convert2weka('test',featName, featTest', label, true); 
ft_test_weka = convert2wekaObj.getInstances();
clear convert2wekaObj;


%% Making Predictions
% actual = cell(ft_test_weka.numInstances()-numExtraClass, 1); %actual labels
% predicted = cell(ft_test_weka.numInstances()-numExtraClass, 1); %predicted labels
prob = zeros(ft_test_weka.numInstances(), ft_test_weka.numClasses()); %probability distribution of the predictions
%the following loop is very slow. We may consider implementing the
%following in JAVA
for z = 1:ft_test_weka.numInstances()
%     actual(z,1) = ft_test_weka.instance(z-1).classValue();
%     predicted(z,1) = metaClassifier.classifyInstance(ft_test_weka.instance(z-1));
%     actual{z,1} = ft_test_weka.instance(z-1).classAttribute.value(ft_test_weka.instance(z-1).classValue()).char();% Modified by GM
%     predicted{z,1} = ft_test_weka.instance(z-1).classAttribute.value(metaClassifier.classifyInstance(ft_test_weka.instance(z-1))).char();% Modified by GM
    prob(z,:) = (classifier.distributionForInstance(ft_test_weka.instance(z-1)))';
end     