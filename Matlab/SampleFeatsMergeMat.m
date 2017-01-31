function [TrainFeats, TestFeats, Stats] = SampleFeatsMergeMat(FeatFolder,EvaImageMark)
TrainFeats = zeros(0,17);
TestFeats = zeros(0,17);
List = dir([FeatFolder,'*.mat']);
List = {List.name};
Stats = zeros(100,3);
count = 1;
    for i = 1:length(List)
        load([FeatFolder,List{i}]);
        temp = List{i};
        if sum(temp(1:6) == EvaImageMark{i,1})==6
            if EvaImageMark{i,2} == 1
                TestFeats = [TestFeats;Feats];
                Stats(i,:) = [1,length(TestFeats),sum(Feats(:,17))];
            else
                TrainFeats = [TrainFeats;Feats];
                Stats(i,:) = [0,length(TestFeats),sum(Feats(:,17))];
            end
        end
    end
return