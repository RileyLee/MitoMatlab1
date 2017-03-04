clear
predPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\OrigDNN\Prediction_OrigDNN\RawPrediction\MitoDNN12_SampleIII1plus2_revised\Test\';
oriPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\OriginalFrames\test\x40\';
outPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\OrigDNN\Prediction_OrigDNN\RawPrediction\MitoDNN12_SampleIII1plus2_revised\markedTest\'

defaultThresh = 0.5;
threshHash = [8, 0.3; 9, 0.6];

fileList = dir([predPath, '*.png']);
fileList = {fileList.name};

detectedRegions = zeros(0, 11);

for i = 1:length(fileList)
    fileName = fileList{i};
    disp(['Processing file ', fileName]);
    group = str2num(fileName(2:3));
    file_no = str2num(fileName(5:6));
    split1 = int16(fileName(7) - 'A') + 1;
    split2 = int16(fileName(8) - 'a') + 1;
    
    oriImage = imread([oriPath, fileName(1:8), '.tiff']);
    
    thresh = defaultThresh * 255;
    if length(find(threshHash(:,1)==group)) ~= 0
        thresh = threshHash(find(threshHash(:,1)==group),2) * 255;
    end
    
    image = imread([predPath, fileName]);
    image_bw = (image >= thresh);
    
    label = bwlabel(image_bw);
    regionInfo = regionprops(label, image, 'Area', 'Centroid', 'MeanIntensity', 'MaxIntensity', 'WeightedCentroid');
    
    for j = 1:size(regionInfo, 1)
        entry = [group, file_no, split1, split2, regionInfo(j).Area, regionInfo(j).Centroid, regionInfo(j).MeanIntensity, regionInfo(j).MaxIntensity, regionInfo(j).WeightedCentroid];
        detectedRegions = [detectedRegions; entry];
        oriImage = markPrediction( oriImage, regionInfo(j).WeightedCentroid(2),regionInfo(j).WeightedCentroid(1) );
        
    end
    imwrite(oriImage, [outPath, fileName(1:8), '.jpg']);
end