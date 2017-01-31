rootPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\mitosis\train\Images\';
segPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\Prediction\NucleiSegment\train\';
oriPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\Frames\train\';
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox')
load('ICPR14_Pyramid.mat')
outPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\GroundTruth\train\';

list = rdir([rootPath,'**\*.jpg']);
list = {list.name};

Label = cell(0,5); cursor = 1;
lastfileName = 'AAAAAAAA';
for i = 1:length(list)
    fullPath = list{i};
    temp = find(fullPath=='\');
    Name = fullPath(temp(end)+1:end);
    temp = find(Name=='_');
    fileName = Name(1:temp(2)-1);
    
    Image = imread(fullPath);
    Idx = str2num(Name(2:3))*100 + str2num(Name(5:6));
    if sum(fileName - lastfileName)~=0
    oriImage20 = imread([oriPath,'x20\',fileName(1:end-1),'.tiff']);
    oriImage40 = imread([oriPath,'x40\',fileName(1:end),'.tiff']);
    disp(['Processing file ',fileName,' .....']);
    end
%     seg20 = imread([segPath,'x20\',fileName(1:end-1),'_norm_Simple Segmentation.png'])>0;
    seg40 = imread([segPath,'x40\',fileName(1:end),'_Simple Segmentation.png'])==2;
%     temp = imread([segPath,'x40\',fileName(1:end),'_norm_Simple Segmentation.png'])==2;
%     if sum(seg40(:))>sum(temp(:))
%         seg40 = temp;
%     end
%     label20 = bwlabel(seg20);
    label40 = bwlabel(seg40);
    if Name(10)=='n'
        Mito = 0;
    else
        Mito = 1;
    end
    Image = (Image(:,:,1)>200).*(Image(:,:,2)>200).*(Image(:,:,3)<50);
    cent = regionprops(bwlabel(Image),'Centroid');
    tempImage = zeros(size(Image));
    pyraIdx = find(pyramidIdx==Idx);
    for j = 1:size(cent,1)
        Cent40 = cent(j).Centroid;
        %         Cent20 = ceil(coordBetwnLayersICPR14(Cent40,fileName(7:8),fileName(7),pyramid(pyraIdx))/2);
        Label(cursor,1:5) = [{fileName},{Idx},{Mito},{Cent40(1)},{Cent40(2)}];
        
        if label40(int16(Cent40(2)),int16(Cent40(1)))~=0
            seg40Layer = uint8(label40 == label40(int16(Cent40(2)),int16(Cent40(1))))*255;
        else
            temp = unique(label40.*double(Image));
            temp = temp(temp~=0);
            seg40Layer = uint8(zeros(size(Image)));
%             if size(temp,1)~=0
%                 for k = 1:length(temp)
%                     seg40Layer = seg40Layer + uint8(label40 == temp(k))*255;
%                 end
%             else
                temp = unique(label40.*double(imdilate(Image,strel('disk',10))));
                temp = temp(temp~=0);
                if size(temp,1)~=0
                    for k = 1:length(temp)
                        seg40Layer = seg40Layer + uint8(label40 == temp(k))*255;
                    end
                else
                    seg40Layer = uint8(Image)*255;
                end
                
%             end
            %             seg40Layer = uint8(Image)*255;
        end
        if Mito == 1
            oriImage40(:,:,1) = oriImage40(:,:,1) + seg40Layer;
            oriImage40(:,:,2) = oriImage40(:,:,2) + seg40Layer;
        else
            oriImage40(:,:,3) = oriImage40(:,:,3) + seg40Layer;
        end
        cursor = cursor + 1;
    end
    if sum(fileName - lastfileName)==0
%     	imwrite(oriImage40,[outPath,fileName,'.png']);
    end
    lastfileName = fileName;
end
