addpath('E:\LeeYuguang\MitosisExtraction\Tasks\AutoParameterTest\matlab2weka\matlab2weka\')
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ML')
javaaddpath('E:\LeeYuguang\MitosisExtraction\Tasks\AutoParameterTest\matlab2weka\matlab2weka\matlab2weka.jar')
javaaddpath('C:\Program Files\Weka-3-6\weka.jar');
load('histDNN.mat')

featName = cell(1,10);  %Title = cell(1,201);
for i = 1:10
    featName(i) = {['A',num2str(i)]};
end

t = templateTree('Surrogate','on')
Mdl = fitensemble(FeatsTrain(:,2:11),FeatsTrain(:,1),'AdaBoostM1',100,t,'cost',[0,1;1,0])
label = predict(Mdl,FeatsTest(:,2:11))

TP = sum(label==1 & FeatsTest(:,1)==1)
FP = sum(label~=1 & FeatsTest(:,1)==1)
FN = sum(label==1 & FeatsTest(:,1)~=1)
Prec = TP / (TP + FP)
Recall = TP / (TP + FN)
F = Prec * Recall / (Prec+Recall)*2
