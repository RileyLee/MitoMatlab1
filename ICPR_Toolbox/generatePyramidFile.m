clear all


folderPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\Frames\train\';
outPath = '';

char = ['a','b','c','d'];
Char = ['A','B','C','D'];

fileList = dir([folderPath,'x40\*.tiff']);
fileList = {fileList.name};

for i = 1:length(fileList)
    temp = fileList{i};
    Name(i) = {temp(1:6)};
end

seriousName = unique(Name);

Layer = cell(1,length(seriousName));
pyramid = struct('layer1',Layer,'layer2',Layer,'layer3',Layer);

for i = 1:length(seriousName)
    pyramid(i).layer1 = cell(2,1);
    pyramid(i).layer2 = cell(2,4);
    pyramid(i).layer3 = cell(2,16);
    Name = seriousName{i};
    pyramid(i).layer1{1,1} = [Name,'.tiff'];
    Info = imfinfo([folderPath,'x10\',Name,'.tiff']);
    temp = [Info.Height,Info.Width];
    pyramid(i).layer1{2,1} = temp;
    for ly1 = 1:4
        Name = [seriousName{i},Char(ly1)];
        pyramid(i).layer2{1,ly1} = [Name,'.tiff'];
        Info = imfinfo([folderPath,'x20\',Name,'.tiff']);
        temp = [Info.Height,Info.Width];
        pyramid(i).layer2{2,ly1} = temp;
        for ly2 = 1:4
            Name1 = [seriousName{i},Char(ly1),char(ly2)];
            pyramid(i).layer3{1,(ly1*4+ly2-4)} = [Name1,'.tiff'];
            Info = imfinfo([folderPath,'x40\',Name1,'.tiff']);
            temp = [Info.Height,Info.Width];
            pyramid(i).layer3{2,(ly1*4+ly2-4)} = temp;
        end
    end
end

% inCoords = [800,300];
% 
% for i = [{'Ac'},{'Bb'},{'Cd'},{'Dc'}];
%     [outCoords,pic] = coordBetwnLayersICPR14(inCoords,[],2,pyramid(1));
%     Image = imread(['E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\Frames\train\x10\A03_00','.tiff']);
%     Image((inCoords(1)-10):(inCoords(1)+10),(inCoords(2)-10):(inCoords(2)+10),2)=255;
%     figure;subplot(1,2,1);imshow(Image)
%     Image = imread(['E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\Frames\train\x20\A03_00',pic,'.tiff']);
%     Image((outCoords(1)-10):(outCoords(1)+10),(outCoords(2)-10):(outCoords(2)+10),2)=255;
%     hold on;subplot(1,2,2);imshow(Image)
% end