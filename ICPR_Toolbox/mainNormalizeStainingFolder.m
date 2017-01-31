rootPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\Frames\test\';
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox')
outPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\normFrames\test\';

list = rdir([rootPath,'**\*.tiff']);
list = {list.name};
for i = 411:length(list)
    Path = list{i};
    temp = find(Path=='\');
    oriPath = Path(1:temp(end));
    addPath = Path(length(rootPath)+1:temp(end));
    Name = Path(temp(end)+1:end);
    outOriPath  = [outPath,addPath];
    mkdir(outOriPath);
    Image = imread(Path);
    [N,temp] = normalizeStaining(Image);
    imwrite(N,[outOriPath,Name(1:end-5),'.png'])
end