function [resultTest, resultTestGroup] = Func_finalAccuracy(filename)
load(filename)
if strcmp(class(PredictionFinal), 'cell')
    PredictionFinal = PredictionFinal{1};
end
if strcmp(class(UnrecordedPredFinal), 'cell')
    UnrecordedPredFinal = UnrecordedPredFinal{1};
end
load('ICPR14split.mat')
load('labelsICPR14csv.mat');
%load('E:\LeeYuguang\MitosisExtraction\DeepLearning\ICPR14_FineTune\fixedLabels_ICPR2014.mat')
table = [Label(:,6), PredictionFinal(:,6:9)];

groups = [3, 4, 5, 7, 10, 11, 12, 14, 15, 17, 18];

groupID = 3;



% Final Accuracy for testing dataset
list = zeros(0,1); 
for i=1:length(UnrecordedPredFinal)
    if (sum(UnrecordedPredFinal(i,1)==testSet)>0)
        list = [list, i];
    end
end


TP = sum(table(testList,1)>0 & table(testList,5)>0);
FP = sum(table(testList,1)==0 & table(testList,5)>0) + length(list);
FN = sum(table(testList,1)>0.2 & table(testList,5)==0);
Prec = TP / (TP + FP);
Recall = TP / (TP + FN);
F_meas = 2 * Prec * Recall / (Prec + Recall);
resultTest = struct('TP', TP, 'FP', FP, 'FN', FN, 'Prec', Prec, 'Recall', Recall, 'F_meas', F_meas, 'groups', 0);



% Groupwise final accuracy of testing dataset
idx = 1;
for groupID = groups
    list = zeros(0,1);
    for i=1:length(UnrecordedPredFinal)
        if (sum(UnrecordedPredFinal(i,1)==testSet)>0 & floor(UnrecordedPredFinal(i,1)/100)~=groupID)
            list = [list, i];
        end
    end
    
    TP_group(idx) = sum(floor(Label(testList,1)/100)~=groupID & table(testList,1)>0 & table(testList,5)>0);
    FP_group(idx) = sum(floor(Label(testList,1)/100)~=groupID & table(testList,1)==0 & table(testList,5)>0) + length(list);
    FN_group(idx) = sum(floor(Label(testList,1)/100)~=groupID & table(testList,1)>0.2 & table(testList,5)==0);
    Prec_group(idx) = TP_group(idx) / (TP_group(idx) + FP_group(idx));
    Recall_group(idx) = TP_group(idx) / (TP_group(idx) + FN_group(idx));
    F_meas_group(idx) = 2 * Prec_group(idx) * Recall_group(idx) / (Prec_group(idx) + Recall_group(idx));
    
    idx = idx + 1;
end

resultTestGroup = struct('TP', TP_group, 'FP', FP_group, 'FN', FN_group, 'Prec', Prec_group, 'Recall', Recall_group, 'F_meas', F_meas_group, 'groups', groups);
