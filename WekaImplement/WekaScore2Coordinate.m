ScorePath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\Morpho_ICPR\HCFeats\HC20_Sample0918_SE5\HC20_Sample0918_Pred\Pred.mat';
LabelPath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\Morpho_ICPR\HCFeats\HC20_Sample0918_SE5\HC20_Sample0918_Label\';
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ReadData\ICPR\')


Label = [];
for File = 51:100
    FileName = [ICPR_FileNameGenerate(File-1),'.mat'];
    load([LabelPath,FileName]);
    Label = [Label;File*ones(length(Labels),1),cell2mat(Labels(:,1))];
end