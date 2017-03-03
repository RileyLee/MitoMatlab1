list = dir('./*orilabel.mat');
list = {list.name};
groups = [3, 4, 5, 7, 10, 11, 12, 14, 15, 17, 18];

TPs = []; FPs = []; FNs = []; Fs = []; Precs = []; Recalls = [];
data_name = [];
classifier_name = [];
TP_groups = zeros(0, length(groups));
FP_groups = zeros(0, length(groups));
FN_groups = zeros(0, length(groups));
for name = list
    filename = name{1};
    temp = strfind(filename, '_');
    classifier_name = [classifier_name, {filename(1:temp(1)-1)}];
    data_name = [data_name, {filename(temp(1)+1:temp(2)-1)}];
    [resultTest, resultTestGroup] = Func_finalAccuracy(filename);
    TPs = [TPs, resultTest.TP];
    FPs = [FPs, resultTest.FP];
    FNs = [FNs, resultTest.FN];
    Fs = [Fs, resultTest.F_meas];
    Precs = [Fs, resultTest.Prec];
    Recalls = [Fs, resultTest.Recall];
    TP_groups = [TP_groups; resultTestGroup.TP];
    FP_groups = [FP_groups; resultTestGroup.FP];
    FN_groups = [FN_groups; resultTestGroup.FN];
end

classifiers = unique(classifier_name);

% for classif = classifiers
%     
% end

figure;
bar(Fs(1:3))
set(gca, 'XTickLabel', list(1:3))

figure;
bar(Fs(4:6))
set(gca, 'XTickLabel', list(4:6))

figure;
bar(Fs(7:10))
set(gca, 'XTickLabel', list(7:10))
