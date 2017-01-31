rootPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\normFrames\test\';
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox')
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\FeatExtract')
outPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\BRnorm\test\';

list = rdir([rootPath,'**\*.png']);
list = {list.name};
for i = 1:length(list)
    disp(['Processing file ',num2str(i),' out of ',num2str(length(list))])
    Path = list{i};
    temp = find(Path=='\');
    oriPath = Path(1:temp(end));
    addPath = Path(length(rootPath)+1:temp(end));
    Name = Path(temp(end)+1:end);
    outOriPath  = [outPath,addPath];
    mkdir(outOriPath);
    Image = imread(Path);
    BR = BandConversionBR(Image,0);
    imwrite(uint8(BR*2.55),[outOriPath,Name(1:end-4),'_norm.png'])
end