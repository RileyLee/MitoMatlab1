function [Conf, Precision, Recall, F1] = Assessment(Label,Scores, Thresh)

Conf = zeros(2,2);
Conf(1,1) = sum(Label > 0 & Scores >= Thresh);
Conf(1,2) = sum(Label > 0 & Scores < Thresh);
Conf(2,1) = sum(Label == 0 & Scores >= Thresh);
Conf(2,2) = sum(Label == 0 & Scores < Thresh);

if (Conf(1,1) + Conf(2,1)) == 0
    Precision = 0;
else
Precision = Conf(1,1) / (Conf(1,1) + Conf(2,1));
end

if (Conf(1,1) + Conf(1,2)) == 0
    Recall = 0;
else
    Recall = Conf(1,1) / (Conf(1,1) + Conf(1,2));
end

F1 = 2* Precision * Recall / (Precision + Recall);


return