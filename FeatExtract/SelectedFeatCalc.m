function [ SelectedFeat ] = SelectedFeatCalc( IM )

    i=1;
%     [IM, map] = imread(FilePath);
    IM = IM(:,:,1:3);
    [ R, G, B, H, La, Lu, BR ] = BandConversion( IM, 0 );
    Color(:,:,1) = R;
    Color(:,:,2) = G;
    Color(:,:,3) = B;
    Color(:,:,4) = H;
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
    
    BR = uint8(round(BR/255*255));
    
    [GLRLM,SI]= grayrlmatrix(BR,'OFFSET',[1;2;3;4],'NumLevels',256); 
    GLRLM = RunLenFilter(GLRLM);
    stats = grayrlpropsSimple(GLRLM,'HGRE');
    HGRE_BR(i) = mean(stats);
%     HGRE_BR(i) = mean(stats(:,7));
    
    clear GLRLM; clear stats;
    [GLRLM,SI]= grayrlmatrix(uint8(R),'OFFSET',[1;2;3;4],'NumLevels',256); 
    GLRLM = RunLenFilter(GLRLM);
    stats = grayrlpropsSimple(GLRLM,'HGRE');
    HGRE_R(i) = mean(stats);
    stats = grayrlpropsSimple(GLRLM,'LGRE');
    LGRE_R(i) = mean(stats);
    
    clear GLRLM;
    [GLRLM,SI]= grayrlmatrix(uint8(B),'OFFSET',[1;2;3;4],'NumLevels',256); 
    GLRLM = RunLenFilter(GLRLM);
    stats = grayrlpropsSimple(GLRLM,'LGRE');
    LGRE_B(i) = mean(stats);
    
    [GLRLM,SI]= grayrlmatrix(uint8(La),'OFFSET',[1;2;3;4],'NumLevels',256); 
    GLRLM = RunLenFilter(GLRLM);
    stats = grayrlpropsSimple(GLRLM,'LGRE');
    LGRE_Llab(i) = mean(stats);

    offsets0 = [0 1; -1 1; -1 0; -1 -1];
    glcms = graycomatrix(double(BR),'GrayLimits', [0,255], 'Offset', offsets0, 'NumLevels', 256);
    glcms = HaraCoFilter(glcms);
    stats1 = graycoprops(glcms,'Energy');
    Energy_BR(i) = mean(stats1.Energy);
    
    H1 = uint8(round(H*255));
    glcms = graycomatrix(H1,'GrayLimits', [0,255], 'Offset', offsets0, 'NumLevels', 256);
    glcms = HaraCoFilter(glcms);
    [idmnc, cshad, corrp] = GLCM_featuresS(glcms,0);
    CShad_V(i) = mean(cshad);
    HaraCorrelation_V(i) = mean(corrp);
    
    glcms = graycomatrix(uint8(R),'GrayLimits', [0,255], 'Offset', offsets0, 'NumLevels', 256);
    glcms = HaraCoFilter(glcms);
    [idmnc, cshad, corrp] = GLCM_featuresS(glcms,0);
    DiffMoments_R(i) = mean(idmnc);
    
    glcms = graycomatrix(uint8(B),'GrayLimits', [0,255], 'Offset', offsets0, 'NumLevels', 256);
    glcms = HaraCoFilter(glcms);
    [idmnc, cshad, corrp] = GLCM_featuresS(glcms,0);
    DiffMoments_B(i) = mean(idmnc);
    
    
    Median_BR(i) = Median(i,7);
    Median_B(i) = Median(i,3);
    Median_Llab(i) = Median(i,5);
    Variance_BR(i) = Variance(i,7);
    Variance_B(i) = Variance(i,3);
    
    SelectedFeat = [Area,SphPerim,Median(7),Median(3),Median(5),Variance(7),Variance(3)...
        Kurtosis(:,1),Kurtosis(:,3),Skew(:,3),Energy_BR,DiffMoments_R,DiffMoments_B,CShad_V,HaraCorrelation_V...
        HGRE_BR,HGRE_R,LGRE_R,LGRE_B,LGRE_Llab];


end

