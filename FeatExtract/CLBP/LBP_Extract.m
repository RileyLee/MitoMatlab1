clear all
SegMapPath = 'E:\LeeYuguang\MitosisExtraction\LBP\segFilteredfinal\Map\';
OriPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\icpr12_IM\';
LabelPath = 'E:\LeeYuguang\MitosisExtraction\LBP\segFilteredfinal\Label\';
OutPath = 'E:\LeeYuguang\MitosisExtraction\LBP\segFilteredfinal\LBPFeats\';
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\FeatExtract')
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox')
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\FeatExtract\CLBP')

% DilateMask = fspecial('gaussian',[9,9]);
% DilateMask = DilateMask > 10^(-16);
TimePerImage = zeros(1,50);

mkdir(OutPath)

for file = 1:50
    clc; tic
    Map2 = imread([SegMapPath,ICPR_FileNameGenerate(file-1),'.png']);
    Map2 = bwlabel(Map2(:,:,1)>0);
    load([LabelPath,ICPR_FileNameGenerate(file-1),'.mat']);
    ImageOri = imread([OriPath,ICPR_FileNameGenerate(file-1),'.bmp']);
    %MapOri = Map1; clear Map1;
    %MapLabel = Out_lb;
%     MapLabel = imdilate(MapLabel, DilateMask);
    
    LBPfeats = [];
    disp(['Processing file ',ICPR_FileNameGenerate(file-1),' ...']);
    lb = [labelInfo{:,3}];
    count = 1;
    
    Map2 = imdilate(Map2,strel('disk',3));
    
    
    
    for Seg = lb
        [x,y] = find(Map2 == Seg);
        temp1 = Map2(min(x):max(x),min(y):max(y)) == Seg;
        temp2 = ImageOri(min(x):max(x),min(y):max(y),:);
        ImagePatch = uint8(zeros(size(temp2)));
        ImagePatch(:,:,1) = temp2(:,:,1) .* uint8(temp1);
        ImagePatch(:,:,2) = temp2(:,:,2) .* uint8(temp1);
        ImagePatch(:,:,3) = temp2(:,:,3) .* uint8(temp1);
        
        [ R, G, B, H, La, Lu, BR ] = BandConversion( ImagePatch, 0 );
        
        LBP_R = clbp(R);
        LBP_B = clbp(B);
        LBP_BR = clbp(BR);
        
        LBPfeats = [LBPfeats;[LBP_R,LBP_B,LBP_BR]];
    end
    
    save([OutPath,ICPR_FileNameGenerate(file-1),'.mat'],'LBPfeats');
end