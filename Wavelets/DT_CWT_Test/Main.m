Path = 'E:\LeeYuguang\M_Cells\training\Non_Mitotic1';

Stats = zeros(0,121);
StatsReal = zeros(1,60);
StatsImage = zeros(1,60);

for Folder = 1
    if Folder < 10
        FolderName = ['\0',num2str(Folder)];
        FolderPath = [Path,FolderName];
    else
        FolderName = ['\',num2str(Folder)];
        FolderPath = [Path,FolderName];
    end
    for File = 1
        if File < 10
            FileName = ['\0',num2str(File)];
            FilePath = [FolderPath,FileName];
        else
            FileName = ['\',num2str(File)];
            FilePath = [FolderPath,FileName];
        end
        PicList = filefinder(FilePath);
        for PicName = PicList
            PicName = char(PicName);
            Pic = str2num(PicName(1:(length(PicName)-4)));
            PicPath = [FilePath, '\', PicName];
            
            IM = uint8(imread(PicPath));
            IM = IM(:,:,1:3);
            IM = rgb2gray(IM);
            IM1 = ones(256,256)* double(IM(1,1));
            IM1(1:size(IM,1),1:size(IM,2)) = IM;
            IM = IM1;
            J = 2;
            [Faf, Fsf] = AntonB;
            [af, sf] = dualfilt1;
            w = NDxWav2DMEX(IM, J, Faf, af,0);

            for k = 1:2
                for j = 1:3
                    for i = 1:2
                        t = w{k}{1}{i}{j};
                        count1 = i*3 + j - 3;
                        count2 = count1 + k*6 - 6;

                        BGcolor = t(size(t,1),size(t,2));
                        temp = (t == BGcolor);
                        IM = find(sum(temp(:,1:size(temp,2)-5))~=size(t,1));
                        Y = find(sum(temp(1:size(temp,1)-5,:)')~=size(t,2));
                        t = t(Y(1):Y(length(Y)),IM(1):length(IM));

                        [M,N]=size(t);
                        for js=1:M     
                            Ej(js)=sum(abs(t(js,:)));
                        end;
                        Etot=sum(Ej);
                        Pj=Ej./Etot;

                        %shannon entropy
                        StatsReal((k-1)*30+(j-1)*10+(i-1)*5+5)=-sum(Pj.*log(Pj));
                        StatsReal((k-1)*30+(j-1)*10+(i-1)*5+4) = sum(sum(t.^2));
                        StatsReal((k-1)*30+(j-1)*10+(i-1)*5+1) = mean(t(find(t~=BGcolor)));
                        StatsReal((k-1)*30+(j-1)*10+(i-1)*5+2) = median(t(find(t~=BGcolor)));
                        StatsReal((k-1)*30+(j-1)*10+(i-1)*5+3) = var(t(find(t~=BGcolor)));
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
                        IM = find(sum(temp(:,1:size(temp,2)-5))~=size(t,1));
                        Y = find(sum(temp(1:size(temp,1)-5,:)')~=size(t,2));
                        t = t(Y(1):Y(length(Y)),IM(1):length(IM));

                        [M,N]=size(t);
                        for js=1:M     
                        Ej(js)=sum(abs(t(js,:)));
                        end;
                        Etot=sum(Ej);
                        Pj=Ej./Etot;

                        %shannon entropy
                        StatsImage(5)=-sum(Pj.*log(Pj));
                        StatsImage(4) = sum(sum(t.^2));
                        StatsImage(1) = mean(t(find(t~=BGcolor)));
                        StatsImage(2) = median(t(find(t~=BGcolor)));
                        StatsImage(3) = var(t(find(t~=BGcolor)));
                    end
                end
            end 
            
            count = 1;
            Temp = zeros(1,121); Temp(121) = 0;
            for j = 1:12
                Temp(count:count+4) = StatsImage(j);
%                 Stats(i,count:count+4) = 
                count = count + 5;
            end
            for j = 1:12
                Stats(i,count:count+4) = cell2mat(WaveletRealStats(i,j));
                count = count + 5;
            end
        end
    end
end


% 
% 
% for TotalNum = 1:length(FileName)
%     temp = char(FileName(TotalNum));
%     Num = str2num(temp(2:(length(temp)-5)));
%     WaveletRealIM(TotalNum,1) = mat2cell(Num);
%     IM = uint8(imread([char(PathName),char(FileName(TotalNum))]));
%     IM = IM(:,:,1:3);
%     IM = rgb2gray(IM);
%     IM1 = ones(256,256)* double(IM(1,1));
%     IM1(1:size(IM,1),1:size(IM,2)) = IM;
%     IM = IM1;
%     J = 2;
%     [Faf, Fsf] = AntonB;
%     [af, sf] = dualfilt1;
%     w = NDxWav2DMEX(IM, J, Faf, af,0);
% %     figure;
% 
%     for k = 1:2
%         for j = 1:3
%             for i = 1:2
%                 t = w{k}{1}{i}{j};
%                 count1 = i*3 + j - 3;
%                 count2 = count1 + k*6 - 6;
%                 
%                 BGcolor = t(size(t,1),size(t,2));
%                 temp = (t == BGcolor);
%                 IM = find(sum(temp(:,1:size(temp,2)-5))~=size(t,1));
%                 Y = find(sum(temp(1:size(temp,1)-5,:)')~=size(t,2));
%                 t = t(Y(1):Y(length(Y)),IM(1):length(IM));
%                 
%                 [M,N]=size(t);
%                 for js=1:M     
%                 Ej(js)=sum(abs(t(js,:)));
%                 end;
%                 Etot=sum(Ej);
%                 Pj=Ej./Etot;
%                 
%                 Temp = zeros(1,5);
%                 %shannon entropy
%                 Temp(5)=-sum(Pj.*log(Pj));
%                 Temp(4) = sum(sum(t.^2));
%                 
%                 
% %                 subplot(2,6,count2);imagesc(t);colormap(gray)
%                 WaveletRealIM(TotalNum,count2+1) = mat2cell(t);
%                 Temp(1) = mean(t(find(t~=BGcolor)));
%                 Temp(2) = median(t(find(t~=BGcolor)));
%                 Temp(3) = var(t(find(t~=BGcolor)));
%                 
%                 WaveletRealStats(TotalNum,count2) = mat2cell(Temp);
%                 
%             end
%         end
%     end 
%     
%     for k = 1:2
%         for j = 1:3
%             for i = 1:2
%                 t = w{k}{2}{i}{j};
%                 count1 = i*3 + j - 3;
%                 count2 = count1 + k*6 - 6;
%                 
%                 BGcolor = t(size(t,1),size(t,2));
%                 temp = (t == BGcolor);
%                 IM = find(sum(temp(:,1:size(temp,2)-5))~=size(t,1));
%                 Y = find(sum(temp(1:size(temp,1)-5,:)')~=size(t,2));
%                 t = t(Y(1):Y(length(Y)),IM(1):length(IM));
%                 
%                 [M,N]=size(t);
%                 for js=1:M     
%                 Ej(js)=sum(abs(t(js,:)));
%                 end;
%                 Etot=sum(Ej);
%                 Pj=Ej./Etot;
%                 
%                 Temp = zeros(1,5);
%                 %shannon entropy
%                 Temp(5)=-sum(Pj.*log(Pj));
%                 Temp(4) = sum(sum(t.^2));
%                 
%                 
% %                 subplot(2,6,count2);imagesc(t);colormap(gray)
%                 WaveletImageIM(TotalNum,count2) = mat2cell(t);
%                 Temp(1) = mean(t(find(t~=BGcolor)));
%                 Temp(2) = median(t(find(t~=BGcolor)));
%                 Temp(3) = var(t(find(t~=BGcolor)));
%                 
%                 WaveletImageStats(TotalNum,count2) = mat2cell(Temp);
%                 
%             end
%         end
%     end 
% end
% 
% Stats = zeros(size(WaveletImageStats,1),121);
% 
% for i = 1:size(WaveletImageStats,1)
%     count = 1;
%     for j = 1:12
%         Stats(i,count:count+4) = cell2mat(WaveletImageStats(i,j));
%         count = count + 5;
%     end
%     for j = 1:12
%         Stats(i,count:count+4) = cell2mat(WaveletRealStats(i,j));
%         count = count + 5;
%     end
%     Stats(i,121) = 1;
% end