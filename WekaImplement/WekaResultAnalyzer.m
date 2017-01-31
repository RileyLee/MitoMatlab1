clc

addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ReadData\ICPR');
LabelPath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\Morpho_ICPR\HCFeats\HC20_Sample0918_SE5\HC20_Sample0918_Label\';
Path = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\Morpho_ICPR\HCFeats\HC20_Sample0918_SE5\HC20_Sample0918_Pred\RF100.csv';
IM_Path = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\icpr12_IM\';
load('EvaList.mat');

% Results = csv2cell(Path,'fromfile');
% Results = Results(14410:end,:);
% 
% load(LabelPath)


Score = zeros(1,length(Results));
for i = 1:length(Results)
%     if isempty(Results{i,3}) == 0
%         temp = Results{i,3};
%     else
        temp = Results{i,2};
%     end
    if temp(1) ~= '*'
        Score(i) = str2num(temp);
    else
        Score(i) = str2num(temp(2:end));
    end
end




% sum(Score >= 0.5)



fileList = dir([LabelPath,'*.mat']);
fileList = {fileList.name};
LabelPred = cell(0,3);
for i = 1:length(fileList)
    load([LabelPath,fileList{i}]);
    LabelPred = [LabelPred;[num2cell(i*ones(length(LabelInfo),1)),LabelInfo]];
end

LabelPred = [num2cell(Score'),LabelPred];

LabelPred1 = cell(0,4);
for i = 1:length(TestNo)
    LabelPred1 = [LabelPred1;LabelPred(find(cell2mat(LabelPred(:,2))==TestNo(i)),:)];
end

LabelPred = LabelPred1;

Temp = cell2mat(LabelPred(:,[1:4]));
Temp = -sortrows(-Temp,1);


PosList = Temp(find(Temp(:,1)>0.5),:);
Center = [floor(PosList(:,4)+PosList(:,6)/2),floor(PosList(:,5)+PosList(:,7)/2)];
PathList = cell(length(Center),1);

for i = 1:length(Center)
    PathList(i) = {[IM_Path,ICPR_FileNameGenerate(PosList(i,2)-1),'.bmp']};
end
PathList = [num2cell(PosList(:,2)),PathList];

Score = PosList(:,1);
Size = 81;

OutPath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\Morpho_ICPR\HCFeats\HC20_Sample0918_SE5\Patches\Positive.png';

PatchDisplay(PathList,Center,Score,Size,OutPath);

