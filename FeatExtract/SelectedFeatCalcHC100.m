function [ SelectedFeat ] = SelectedFeatCalcHC100( IM )

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
    
    
    for channel = [1,3:7]
        Image = Color(:,:,channel);
        [GLRLM,SI]= grayrlmatrix(Image,'OFFSET',[1;2;3;4],'NumLevels',256); 
        GLRLM = RunLenFilter(GLRLM);
        
        stats = grayrlpropsSimple(GLRLM,'HGRE');
        HGRE(channel) = mean(stats);
        stats = grayrlpropsSimple(GLRLM,'LGRE');
        LGRE(channel) = mean(stats);
        stats = grayrlpropsSimple(GLRLM,'LRE');
        LRE(channel) = mean(stats);
        stats = grayrlpropsSimple(GLRLM,'SRE');
        SRE(channel) = mean(stats);
        stats = grayrlpropsSimple(GLRLM,'SRLGE');
        SRLGE(channel) = mean(stats);
        stats = grayrlpropsSimple(GLRLM,'LRLGE');
        LRLGE(channel) = mean(stats);
        stats = grayrlpropsSimple(GLRLM,'LRHGE');
        LRHGE(channel) = mean(stats);
        stats = grayrlpropsSimple(GLRLM,'GLNU');
        GLNU(channel) = mean(stats);
        stats = grayrlpropsSimple(GLRLM,'RLNU');
        RLNU(channel) = mean(stats);
        
        
        offsets0 = [0 1; -1 1; -1 0; -1 -1];
        glcms = graycomatrix(double(Image),'GrayLimits', [0,255], 'Offset', offsets0, 'NumLevels', 256);
        glcms = HaraCoFilter(glcms);
        stats1 = graycoprops(glcms,'Energy');
        Energy(channel) = mean(stats1.Energy);
        stats1 = graycoprops(glcms,'Correlation');
        Correlation(channel) = mean(stats1.Correlation);
        [idmnc, cshad, corrp] = GLCM_featuresS(glcms,0);
        CShad(channel) = mean(cshad);
        HaraCorrelation(channel) = mean(corrp);
        DiffMoments(channel) = mean(idmnc);
        
        
        
    end
    
    
    SelectedFeat = [Area,SphPerim,Mean([1,3:7]),Median([1,3:7]),...
        Variance([1,3:7]),Kurtosis([1,3:7]),Skew([1,3:7]),Energy([1,3:7]),DiffMoments([1,3:7]),CShad([1,3:7]),...
        HaraCorrelation([1,3:7]),Correlation([1,3:7]),HGRE([1,3:7]),LGRE([1,3:7]),LRE([1,3:7]),SRE([1,3:7]),SRLGE([1,3:7]),LRLGE([1,3:7]),...
        LRHGE([1,3:7]),GLNU([1,3:7]),RLNU([1,3:7])];


end

