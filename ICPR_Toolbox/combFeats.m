clear all
rootPath = 'E:\LeeYuguang\MitosisExtraction\IrshadSegment\features\LCP_R7\';
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox')
testFile = 'EvaListIV.mat';
outPath = 'E:\LeeYuguang\MitosisExtraction\IrshadSegment\Irshad_LCPR7_';

labelPath = 'E:\LeeYuguang\MitosisExtraction\IrshadSegment\labels\';

TestNo = [1,9,15,17,20,21,22,24,28,31,32,35,44,48,50];
% load(testFile);

testFeats = [];
trainFeats = [];
for i = [1:50]
    Path = [rootPath,ICPR_FileNameGenerate(i-1),'.mat'];
    load(Path);
    Path = [labelPath,ICPR_FileNameGenerate(i-1),'.mat'];
    load(Path);
%     if i<21 | i>30
%         label = cell2mat(label(:,1));
%     else
        label = cell2mat(labelInfo(:,1));
%     end

%     HCfeats = LBPfeats(:,256*2+1:end);
    
%     HCfeats = Feats(:,[1:5,7]);
    
%     temp = HCfeats(:,2:end-1);
%     temp(temp>200) = 200;
%     HCfeats(:,2:end-1) = temp;

    if sum(TestNo == i) > 0
        testFeats = [testFeats;[label,HCfeats]];
    else
        trainFeats = [trainFeats;[label,HCfeats]];
    end
    
end



Label = cell(size(testFeats,1),1);
Label(testFeats(:,1)==1) = {'Mito'};
Label(testFeats(:,1)==0) = {'Non'};

Title = cell(1,size(HCfeats,2)+1);
Title(1) = {'Category'};
for i = 1:size(HCfeats,2)
    Title(i+1) = {['A',num2str(i)]};
end

DataF = num2cell(testFeats(:,2:end));
Final = [Title;[Label,DataF]];

ds = cell2dataset(Final);
export(ds,'file',[outPath,'Test.csv'],'delimiter',',')



Label = cell(size(trainFeats,1),1);
Label(trainFeats(:,1)==1) = {'Mito'};
Label(trainFeats(:,1)==0) = {'Non'};

Title = cell(1,size(DataF,2));
Title(1) = {'Category'};
for i = 1:size(HCfeats,2)
    Title(i+1) = {['A',num2str(i)]};
end

DataF = num2cell(trainFeats(:,2:end));
Final = [Title;[Label,DataF]];

ds = cell2dataset(Final);
export(ds,'file',[outPath,'Train.csv'],'delimiter',',')



%%
% Feature Normalization
% totalFeats = [testFeats;trainFeats];
% newFeats = totalFeats;
% for i = 2:21
%     feat = totalFeats(:,i);
%     feat = (feat - min(feat))/(max(feat)-min(feat));
%     newFeats(:,i) = feat;
% end
% 
% newTestFeats = newFeats(1:length(testFeats),:);
% newTrainFeats = newFeats(length(testFeats)+1:end,:);

% newTestFeats = testFeats;
% newTrainFeats = trainFeats;
% 
% csvwrite([outPath,'Test.csv'],newTestFeats);
% csvwrite([outPath,'Train.csv'],newTrainFeats);