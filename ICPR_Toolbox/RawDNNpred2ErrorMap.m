function [errorMap, ConfMat] = RawDNNpred2ErrorMap(Pred, GroundTruth, Thresh)

    R = zeros(size(Pred,1),size(Pred,2)); G = R; B = R;

    Pred1 = Pred > Thresh;     % Change this value to adjust the amount of predicted mitosis displayed in the output images.
    MitoNum = max(max(GroundTruth));
    MitoStatus = zeros(MitoNum,1);
    
    Mito_lb = bwlabel(Pred1);
    PredNum = max(max(Mito_lb)); FP = 0;
    for j = 1:PredNum
        PredCheck(j) = 0;
        tempMap = double(Mito_lb==j).*GroundTruth;
        if max(max(tempMap)) > 0
            MitoStatus(max(max(tempMap))) = 1;
            PredCheck(j) = 1;
            G(find(Mito_lb==j)) = 255;
        end
        if PredCheck(j) == 0
            B(find(Mito_lb==j)) = 255;
            FP = FP + 1;
        end
    end
    
    for j = 1:MitoNum
        if MitoStatus(j) == 0
            R(find(GroundTruth==j)) = 255;
%             FN = FN + 1;
        end
    end
    
    TP = sum(MitoStatus);
    FN = MitoNum - TP;
    TN = 0;
    ConfMat = [TP,FP;FN,TN];
    
    errorMap(:,:,1) = uint8(R);
    errorMap(:,:,2) = uint8(ceil(double(G) .* (double(Pred) / 255)));
    errorMap(:,:,3) = uint8(ceil(double(B) .* (double(Pred) / 255)));
    
return