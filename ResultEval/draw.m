clear
list = dir('C:\Users\ylee3\Desktop\Unsure\*.png');
Image = uint8(zeros(1000,1000,3));
idx = 0;
for i=1:115
    Name = list(i).name;
    IM = imread(['C:\Users\ylee3\Desktop\Unsure\', Name]);
    try
        IM = IM(51:150,51:150,:);
        row = floor(idx / 10);
        col = idx - row * 10;
        Image(row*100+1:row*100+size(IM, 1), col*100+1:col*100+size(IM, 2), :) = IM;
        idx = idx + 1;
    catch
    end

end