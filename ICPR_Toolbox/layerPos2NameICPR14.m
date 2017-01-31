function [ Name, Idx ] = layerPos2NameICPR14( x , y )

Data = [1,2,5,6;3,4,7,8;9,10,13,14;11,12,15,16];
Data1 = [1,2,5,6];
char = ['a','b','c','d'];
Char = ['A','B','C','D'];

if x > 4 || y > 4
    disp('Invalid Input, layerPos2NameICPR14!!!')
    Name = [];
else
    Num = (x-1) * 4 + y;
    [xPos, yPos ] = find(Data==Num);
    yPos = find(Data1 == (Num - Data(xPos,1)+1));
end

Name = [Char(xPos),char(yPos)];
Idx = (xPos-1)*4 + yPos;