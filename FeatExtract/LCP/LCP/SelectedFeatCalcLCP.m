function [ SelectedFeat ] = SelectedFeatCalcLCP( IM )

    i=1;
%     [IM, map] = imread(FilePath);
    IM = IM(:,:,1:3);
    [ R, G, B, H, La, Lu, BR ] = BandConversion( IM, 0 );
    Color(:,:,1) = R;
    Color(:,:,2) = G;
    Color(:,:,3) = B;
    Color(:,:,4) = uint8(H*255);
    Color(:,:,5) = La;
    Color(:,:,6) = Lu;
    Color(:,:,7) = BR;
    
    
    IM1 = rgb2gray(IM);
    Props = regionprops(IM1>0, 'Area', 'Perimeter', 'BoundingBox'); Perim(i) = Props.Perimeter; Area(i) = Props.Area;
    Round(i) = (4*Area(i)*pi)/Perim(i)^2;
    temp2 = Props.BoundingBox;
    Elong(i) = abs((temp2(1) - temp2(3)) / (temp2(2) - temp2(4)));
    
    [X,Y]=find(IM1>0);
    Coord = [X,Y];
    C = cov(X,Y);
    [Vector,Values] = eig(C);
    Elong1(i) = max(max(Values))/min(min(Values+10000*[0,1;1,0]));      %Eigen based
    
    [ NumJoint(i), NumEnd(i), Elong2(i) ] = IM_Morph( IM1 );   %Skelenton based
    SphPerim(i) = sqrt(Area(i) / pi)*2*pi;
%     SphPerim(i) = (sum(sum(temp))*0.75/pi)^(1/3)*pi*2;
    
%     Spher(i) = ;
    
    for j = 1:7
        temp = double(Color(:,:,j));
        temp = temp(find(temp>0));
        Mean(i,j) = mean(temp(:));
        Median(i,j) = median(temp(:));
        Variance(i,j) = (std(temp(:)))^2;
        Kurtosis(i,j) = kurtosis(temp(:));
        Skew(i,j) = skewness(temp(:));
    end
    
    if size(IM,1)>=3 && size(IM,2)>=3
        mapping=getmapping(8,'riu2');
        Feats = [];
        for channel = [1,3,7]
            Image = Color(:,:,channel);
            Feats= [Feats,LCP(double(Image), 2, 8,mapping,'i')'];
            
        end
    else
        Feats = zeros(1,243);
    end
    
    
    SelectedFeat = [Area,SphPerim,Mean([1,3:7]),Median([1,3:7]),...
        Variance([1,3:7]),Kurtosis([1,3:7]),Skew([1,3:7]),Feats];


end

