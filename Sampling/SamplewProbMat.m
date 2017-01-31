function SamplewProbMat(OriImage, ProbMap, sampleSize, Path,Name)

OriImage = uint8(AddMargin(OriImage,80,1));
ProbMap = AddMargin(ProbMap,80,0);


Prob = double(ProbMap(find(ones(size(ProbMap)))));
[X,Y] = find(ones(size(ProbMap)));
cumProb = cumsum(Prob);
sumProb = sum(Prob);
BoundIM = [size(OriImage,1),size(OriImage,2)];

ImageSet = cell(1,0);
NameSet = cell(1,0);

for i = 1:sampleSize
    Mark = 1;
    val = rand(1)*sumProb;
    position = find(cumProb>val);
    position = position(1);
    position1 = find(cumProb<val);
    position1 = position1(end)+1;
    CenterMito = [X(position),Y(position)];
%     CenterMito = CenterMito + 80;
    
    NewBound = [CenterMito(1)-80,CenterMito(1)+80;(CenterMito(2)-80),(CenterMito(2)+80)];
    
    IM_Crop = OriImage(NewBound(1,1):NewBound(1,2),NewBound(2,1):NewBound(2,2),:);

    
    Angle = rand(1)*359.9999999;
    OriImageOut = imrotate(IM_Crop,Angle);
    CenterOriImage = int16([(size(OriImageOut,1)+1)/2,(size(OriImageOut,2)+1)/2]);
    OriImageOut = OriImageOut((CenterOriImage(1)-50):(CenterOriImage(1)+50),(CenterOriImage(2)-50):(CenterOriImage(2)+50),:);
    if rand(1) > 0.5
        OriImageOut = flipdim(OriImageOut,2);
    end
    
    if Mark == 1
    %imwrite(OriImageOut,[Path,Name,'_',num2str(i),'.png'])
        ImageSet = [ImageSet, {OriImageOut}];
        NameSet = [NameSet, {[Name,'_',num2str(i),'.png']}];
    end
    
end

if size(NameSet,2)>0
save([Path, Name,'.mat'], 'ImageSet', 'NameSet');
end