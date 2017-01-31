clear all
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox')
addpath('E:\LeeYuguang\MitosisExtraction\Original Datasets\icpr12_IM')
addpath('E:\LeeYuguang\MitosisExtraction\PreliminaryResults\Morpho_ICPR\Samples\SampleMorph2_0918\ClassifierFilteredSeg\RF500')
OutPath = 'E:\LeeYuguang\MitosisExtraction\Tasks\MorphoExtract_ICPR0918\SampleNonMito.png';

load('Labels_Sample0918.mat')
load('CenterInfo_0918.mat');

MitoPool = find(CenterInfo(:,2)==1);
NonPool = find(CenterInfo(:,2)~=1);

Quantity = 17*17;

SamplePos = sort(datasample(NonPool,Quantity));
SampleInfo = CenterInfo(SamplePos,:);

Center = [floor(SampleInfo(:,3) + SampleInfo(:,5)/2),floor(SampleInfo(:,4) + SampleInfo(:,6)/2)];

ImageList = cell(length(Center),2);
ImageList(:,1) = num2cell(SampleInfo(:,1));
MapList = cell(length(Center),2);
MapList(:,1) = num2cell(SampleInfo(:,1));
File = unique(SampleInfo(:,1));
for i = 1:length(File)
    ImageList(find(SampleInfo(:,1)==File(i)),2) = {[ICPR_FileNameGenerate(File(i)-1),'.bmp']};
    MapList(find(SampleInfo(:,1)==File(i)),2) = {[ICPR_FileNameGenerate(File(i)-1),'.mat']};
end
SegPatchDisplay(ImageList,MapList,SampleInfo(:,7),[],81,OutPath);
