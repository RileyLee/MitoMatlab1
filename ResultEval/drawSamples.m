clear;
root = 'C:\Users\ylee3\Desktop\Unsure\';
format = '*.png'
outName = 'picCollection.png'
list = dir([root, format]);
list = [list.name];
imPerRow = 10;
outImage = uint8(zeros(1000,1000,3));
idx = 0;
for i=1:length(list)
    image = imread([root, Name]);
    try
	h = size(image, 1);
	w = size(image, 2);
	centR = floor(h / 2);
	centC = floor(w / 2);
        image = image ((centR-49):(centR+50),(centC-49):(centC+50),:);
        row = floor(idx / imPerRow);
        col = idx - row * imPerRow;
        outImage(row*100+1:row*100+size(image, 1), col*100+1:col*100+size(image, 2), :) = image ;
        idx = idx + 1;
    catch
    end
end

imwrite(outImage, outName);