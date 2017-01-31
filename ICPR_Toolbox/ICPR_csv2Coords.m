function CoordsOut = ICPR_csv2Coords(Path)

Center = csvread(Path);
CoordsOut = cell(1,size(Center,1));
for line = 1:size(Center,1)
    lastZero = find(Center(line,:)~=0);
    lastZero = lastZero(end);
    Coords = zeros(ceil(lastZero/2),2);
    Coords(:,2) = Center(line,1:2:ceil(lastZero/2)*2)'+1;
    Coords(:,1) = Center(line,2:2:ceil(lastZero/2)*2)'+1;
    CoordsOut(line) = {Coords};
end


return