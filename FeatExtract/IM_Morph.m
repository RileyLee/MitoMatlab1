function [ NumJoint, NumEnd, Length ] = IM_Morph( IM )

IM2 = bwmorph(IM,'skel',Inf);
A = [1 1 1;1 0 1;1 1 1];
IM3 = filter2(A,IM2);

B1 = [0 0 0;0 0 0;1 1 1];
B2 = [1 1 1;0 0 0;0 0 0];
B3 = [1 0 0;1 0 0;1 0 0];
B4 = [0 0 1;0 0 1;0 0 1];
IM4 = filter2(B1,IM2);
IM4(find(IM4>0)) = IM4(find(IM4>0)) - 1;
IM5 = filter2(B2,IM2);
IM5(find(IM5>0)) = IM5(find(IM5>0)) - 1;
IM6 = filter2(B3,IM2);
IM6(find(IM6>0)) = IM6(find(IM6>0)) - 1;
IM7 = filter2(B4,IM2);
IM7(find(IM7>0)) = IM7(find(IM7>0)) - 1;

IM8 = IM3 - IM4 - IM5 - IM6 - IM7;
IM8 = IM8 .* double(IM2);

NumJoint = sum(sum(IM8>2));
NumEnd = sum(sum(IM8==1));
Length = sum(sum(IM2));

end

