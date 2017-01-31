segPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\Prediction\NucleiSegment\train\';
oriPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\Frames\train\';
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox')
load('labelsICPR14csv.mat')
outPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\GroundTruth\scale\train\';

mkdir(outPath)

Char = ['A','B','C','D'];
char = ['a','b','c','d'];
list = unique(Label(:,1)*100+Label(:,2)*10+Label(:,3));

cursor = 1;
lastfileName = 'AAAAAAAA';

yellow = [255,255,0];
green = [0,255,0];
lblue = [0,255,255];
blue1 = [0,127,255];
blue = [0,0,255];

Color = [yellow;green;lblue;blue1;blue];
Score = [1,0.8,0.65,0.2,0];

for i = 1:length(list)
    temp = num2str(list(i));
    fileName = ['A',num2str(str2num(temp(1)),'%02d'),'_',num2str(str2num(temp(2:3)),'%02d'),Char(str2num(temp(4))),char(str2num(temp(5)))];
    
    mitoList = Label(find((Label(:,1)*100+Label(:,2)*10+Label(:,3))==list(i)),:);
    
    oriImage40 = imread([oriPath,'x40\',fileName(1:end),'.tiff']);
    disp(['Processing file ',fileName,' .....']);

    seg40 = imread([segPath,'x40\',fileName(1:end),'_Simple Segmentation.png'])==2;

    label40 = bwlabel(seg40);
    
    
    for j = 1:5
        Image = zeros([size(seg40)]);
        Coord = mitoList(mitoList(:,end)==Score(j),4:5);
        for z = 1:size(Coord,1)
            Image(Coord(z,2),Coord(z,1)) = 1;
        end
        Image = imdilate(Image,strel('disk',10));
        temp = unique(label40.*double(Image));
        temp = temp(temp~=0);
        seg40Layer = uint8(zeros(size(Image)));
        temp = unique(label40.*double(imdilate(Image,strel('disk',10))));
        temp = temp(temp~=0);
        if size(temp,1)~=0
            for k = 1:length(temp)
                seg40Layer = seg40Layer + uint8(label40 == temp(k))*1;
            end
        else
            seg40Layer = uint8(Image)*1;
        end
        for k = 1:3
            oriImage40(:,:,k) = oriImage40(:,:,k) + seg40Layer*Color(j,k);
        end
    end
    
    imwrite(oriImage40,[outPath,fileName,'.png']);

end
