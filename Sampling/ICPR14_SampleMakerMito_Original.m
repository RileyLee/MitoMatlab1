%%

% Current code cannot handle corner samples

load('FixedICPR14MitoCenter.mat')

CHAR = 'abcd';
CHAR_cap = 'ABCD';
oriPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\OriginalFrames\train\x40\';
gtPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\GroundTruth\train\relabeled_x40_v2\';
outPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\ICPR14_SamplePatches\SampleIV\Mitosis\';
Loc = 0;

patchSize = 101;
cropSizeHalf = floor(1.5 * (patchSize-1) / 2);
cropSize = floor(1.5 * (patchSize-1));

fileListFull = Label(:,1)*100 + Label(:,2)*10 + Label(:,3);
fileList = unique(fileListFull);


%% Clear up folders in outPath
List = dir(outPath);
List = {List(3:end).name};
for i = 1:length(List)
  path = [outPath,List{i}];
  rmdir(path,'s');
  mkdir(path);
end



%% Making Samples
for i = 1:size(fileList,1)

  fileName = ['A', num2str(floor(fileList(i)/10000), '%02d')];
  temp = fileList(i) - floor(fileList(i)/10000) * 10000;
  fileName = [fileName,'_',num2str(floor(temp/100), '%02d')];
  temp = temp - floor(temp/100) * 100;
  fileName = [fileName,CHAR_cap(floor(temp/10)), CHAR(mod(temp,10))];

  imageGT = imread([gtPath, fileName, '.png']);
  
  markedRegion = (imageGT(:,:,1) > 235).*(imageGT(:,:,2) > 235).* ...
        (imageGT(:,:,3) < 20) + (imageGT(:,:,1) < 20).*(imageGT(:,:,2) < 20).* ...
        (imageGT(:,:,3) >= 235);
    
  path = [oriPath,fileName,'.tiff'];
  image = imread(path);
% %   imageGT = uint8(AddMargin(imageGT, 80, 0));
  imageMargin = uint8(AddMargin(image, 80, 2));
  locInfo = Label(fileListFull==fileList(i), :);

  disp(['Processing File ',fileName]);
  for mitoID = 1: size(locInfo,1)
    Loc = Loc + 1;

    h = size(image,1);
    w = size(image,2);
    c = size(image,3);
    score = locInfo(mitoID,6);

    centMitoGT = round(locInfo(mitoID,[5,4]));
    sampleID = 0;

    Mark = 0;
    for m = -11:1:11
      for n = -11:1:11
        if score==0 && rand(1)>0.2
          continue;
        elseif rand(1) > 0.5
            continue;
        end

        centMito = [(centMitoGT(1) + m),(centMitoGT(2) + n)];
        dist2GT = sqrt((centMito(1) - centMitoGT(1))^2 + (centMito(2) - centMitoGT(2))^2);

        if centMito(1)>h || centMito(2)>w || centMito(1)<1 || centMito(2)<1
          continue;
        end

        if dist2GT <= 9 && markedRegion(centMito(1), centMito(2)) ~=0
          sampleID = sampleID + 1;
          patchBound = [centMito(1), centMito(1)+160; (centMito(2)), (centMito(2)+160)];

          try
            if patchBound(1,1)>0 && patchBound(1,2)<=h && patchBound(2,1)>0 && patchBound(2,2)<=w
              IM_Crop = imageMargin(patchBound(1,1):patchBound(1,2),patchBound(2,1):patchBound(2,2),:);
            end

            Angle = rand(1)*359.9999999;
            outPatch = imrotate(IM_Crop,Angle);
            CenterImage = [(size(outPatch,1)+1)/2,(size(outPatch,2)+1)/2];
            outPatch = outPatch(ceil(CenterImage(1)-50):ceil(CenterImage(1)+50),ceil(CenterImage(2)-50):ceil(CenterImage(2)+50),:);
            if rand(1) > 0.5
              outPatch = flipdim(outPatch,2);
            end


            patchName = [fileName,'_',num2str(mitoID,'%02d')];
            patchName = [patchName,'_',num2str(sampleID,'%04d'),'.tif'];
            patchName = [outPath, 'pt', num2str(floor(score*10)), '\', patchName];

            imwrite(outPatch, patchName);
          catch exception

            if Mark == 0
              disp(['Exception!!!'])
              Mark = 1;
            end
          end
        end
      end
    end



  end


end
