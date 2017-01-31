addpath('F:\UW\Winter2015\Linda\Mitosis_1');

[FileName, PathName] = uigetfile('F:\UW\Winter2015\Linda\Mitosis_1','MultiSelect','On');

WaveletRealIM = cell(length(FileName),13);
WaveletRealStats = cell(length(FileName),12);
WaveletImageIM = cell(length(FileName),12);
WaveletImageStats = cell(length(FileName),12);

for pos = 1:length(FileName)
    temp = char(FileName(pos));
    Num = str2num(temp(2:(length(temp)-5)));
    WaveletRealIM(pos,1) = mat2cell(Num);
    x = uint8(imread([char(PathName),char(FileName(pos))]));
    x = x(:,:,1:3);
    x = rgb2gray(x);
    x1 = ones(256,256)* double(x(1,1));
    x1(1:size(x,1),1:size(x,2)) = x;
    x = x1;
    J = 2;
    [Faf, Fsf] = AntonB;
    [af, sf] = dualfilt1;
    w = NDxWav2DMEX(x, J, Faf, af,0);
%     figure;

    for k = 1:2
        for j = 1:3
            for i = 1:2
                t = w{k}{1}{i}{j};
                count1 = i*3 + j - 3;
                count2 = count1 + k*6 - 6;
                
                BGcolor = t(size(t,1),size(t,2));
                temp = (t == BGcolor);
                X = find(sum(temp(:,1:size(temp,2)-5))~=size(t,1));
                Y = find(sum(temp(1:size(temp,1)-5,:)')~=size(t,2));
                t = t(Y(1):Y(length(Y)),X(1):length(X));
                
                [M,N]=size(t);
                for js=1:M     
                Ej(js)=sum(abs(t(js,:)));
                end;
                Etot=sum(Ej);
                Pj=Ej./Etot;
                
                Temp = zeros(1,5);
                %shannon entropy
                Temp(5)=-sum(Pj.*log(Pj));
                Temp(4) = sum(sum(t.^2));
                
                
%                 subplot(2,6,count2);imagesc(t);colormap(gray)
                WaveletRealIM(pos,count2+1) = mat2cell(t);
                Temp(1) = mean(t(find(t~=BGcolor)));
                Temp(2) = median(t(find(t~=BGcolor)));
                Temp(3) = var(t(find(t~=BGcolor)));
                
                WaveletRealStats(pos,count2) = mat2cell(Temp);
                
            end
        end
    end 
    
    for k = 1:2
        for j = 1:3
            for i = 1:2
                t = w{k}{2}{i}{j};
                count1 = i*3 + j - 3;
                count2 = count1 + k*6 - 6;
                
                BGcolor = t(size(t,1),size(t,2));
                temp = (t == BGcolor);
                X = find(sum(temp(:,1:size(temp,2)-5))~=size(t,1));
                Y = find(sum(temp(1:size(temp,1)-5,:)')~=size(t,2));
                t = t(Y(1):Y(length(Y)),X(1):length(X));
                
                [M,N]=size(t);
                for js=1:M     
                Ej(js)=sum(abs(t(js,:)));
                end;
                Etot=sum(Ej);
                Pj=Ej./Etot;
                
                Temp = zeros(1,5);
                %shannon entropy
                Temp(5)=-sum(Pj.*log(Pj));
                Temp(4) = sum(sum(t.^2));
                
                
%                 subplot(2,6,count2);imagesc(t);colormap(gray)
                WaveletImageIM(pos,count2) = mat2cell(t);
                Temp(1) = mean(t(find(t~=BGcolor)));
                Temp(2) = median(t(find(t~=BGcolor)));
                Temp(3) = var(t(find(t~=BGcolor)));
                
                WaveletImageStats(pos,count2) = mat2cell(Temp);
                
            end
        end
    end 
end

Stats = zeros(size(WaveletImageStats,1),121);

for i = 1:size(WaveletImageStats,1)
    count = 1;
    for j = 1:12
        Stats(i,count:count+4) = cell2mat(WaveletImageStats(i,j));
        count = count + 5;
    end
    for j = 1:12
        Stats(i,count:count+4) = cell2mat(WaveletRealStats(i,j));
        count = count + 5;
    end
    Stats(i,121) = 1;
end