Path1 = 'E:\LeeYuguang\MitosisExtraction\SuperClassifier\DNN_Candidate\pt5\';
Path2 = 'E:\LeeYuguang\MitosisExtraction\SuperClassifier\DNN_Candidate\ptou5\';
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox\');

TestNo = [1,9,15,17,20,21,22,24,28,31,32,35,44,48,50];
LabelTrain = zeros(0,1);
LabelTest = zeros(0,1);

for i = 1:50
    IM1 = imread([Path1,ICPR_FileNameGenerate(i-1),'.png']);
    IM2 = imread([Path2,ICPR_FileNameGenerate(i-1),'.png']);
    IM1 = IM1(:,:,1)>0;
    IM2 = IM2(:,:,1)>0;
    
    label = bwlabel(IM2);
    idx = unique(label.*double(IM1));
    idx= idx(2:end);
    L = zeros(max(label(:)),1);
    L(idx) = 1;
    if sum(TestNo==i)==0
        LabelTrain = [LabelTrain;L];
    else
        LabelTest = [LabelTest;L];
    end
end