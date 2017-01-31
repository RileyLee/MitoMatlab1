function [outCoords, pic] = coordBetwnLayersICPR14(inCoords, ly1, ly2, Pyramid)

char = ['a','b','c','d'];
Char = ['A','B','C','D'];
Coords = [0,0];


if length(ly1)==2
    ly1NoA = find(ly1(1)==Char);
    ly1NoAxy = [ceil(ly1NoA/2),ly1NoA-(ceil(ly1NoA/2)-1)*2];
    ly1NoB = find(ly1(2)==char);
    ly1NoBxy = [ceil(ly1NoB/2),ly1NoB-(ceil(ly1NoB/2)-1)*2];
    ly1Noxy = (ly1NoAxy - 1)*2 + ly1NoBxy;
    for i = 1:(ly1Noxy(1) - 1)
        [~,Idx] = layerPos2NameICPR14(i,1);
        temp = Pyramid.layer3{2,Idx};
        Coords(1) = Coords(1) + temp(1);
    end
    for j = 1:(ly1Noxy(2) - 1)
        [~,Idx] = layerPos2NameICPR14(1,j);
        temp = Pyramid.layer3{2,Idx};
        Coords(2) = Coords(2) + temp(2);
    end
    Coords = Coords + inCoords;
elseif length(ly1)==1
    ly1No = find(Char==ly1{1});
    ly1Noxy = [ceil(ly1No/2),ly1No-(ceil(ly1No/2)-1)*2];
    for i = 1:(ly1Noxy(1) - 1)
        Idx = (i-1)*2+1;
        temp = Pyramid.layer2{2,Idx};
        Coords(1) = Coords(1) + temp(1);
    end
    for j = 1:(ly1Noxy(2) - 1)
        Idx = j;
        temp = Pyramid.layer2{2,Idx};
        Coords(2) = Coords(2) + temp(2);
    end
    Coords = ((Coords + inCoords)-1)*2+1;
else
    Coords = (inCoords-1)*4+2;
end


temp1 = 0;
if ly2 == 1
    Coords2 = Coords / 4;
    outCoords = ceil(Coords);
    pic = '';
elseif ly2 == 2
    Coords2 = Coords / 2;
    temp = Pyramid.layer2{2,1};
    if Coords2(1) > temp(1)
        Coords2(1) = Coords2(1) - temp(1);
        temp1 = 1;
    end
    if Coords2(2) > temp(2)
        Coords2(2) = Coords2(2) - temp(2);
        temp1 = temp1 * 2 + 2;
    else
        temp1 = temp1 * 2 + 1;
    end
    outCoords = ceil(Coords2);
    pic(1) = Char(temp1);
else
    Coords2 = Coords;
    idxX = 1;
    while Coords2(1)>0
        [~,Idx] = layerPos2NameICPR14(idxX,1);
        temp = Pyramid.layer3{2,Idx};
        Coords2(1) = Coords2(1) - temp(1);
        idxX = idxX + 1;
    end
    Coords2(1) = Coords2(1) + temp(1);
    idxX = idxX - 1;
    
    idxY = 1;
    while Coords2(2)>0
        [~,Idx] = layerPos2NameICPR14(1,idxY);
        temp = Pyramid.layer3{2,Idx};
        Coords2(2) = Coords2(2) - temp(2);
        idxY = idxY + 1;
    end
    Coords2(2) = Coords2(2) + temp(2);
    idxY = idxY - 1;
    
    [Name,~] = layerPos2NameICPR14(idxX,idxY);
    outCoords = Coords2;
    pic = Name;
end



