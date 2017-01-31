function [ phi, Contour ] = LevelSet( Img, Img2, iter_outer, Display, LevelPara )


% addpath('DRLSE_v0');
%% parameter setting
timestep=8;  % time step
mu=0.2/timestep;  % coefficient of the distance regularization term R(phi)
iter_inner=20;
if length(iter_outer)==0
    iter_outer=120;
end

if length(LevelPara) == 0
    lambda=5; % coefficient of the weighted length term L(phi)
    alfa=2;  % coefficient of the weighted area term A(phi)
    epsilon=1.5; % papramater that specifies the width of the DiracDelta function
else
    lambda = LevelPara(1);
    alfa = LevelPara(2);
    epsilon = LevelPara(3);
end

sigma=1.5;     % scale parameter in Gaussian kernel
G=fspecial('gaussian',3,sigma);
Img_smooth=conv2(Img,G,'same');  % smooth image by Gaussiin convolution
[Ix,Iy]=gradient(Img_smooth,2.2,2.2);
f=Ix.^2+Iy.^2;
g=1./(1+f);  % edge indicator function.

% initialize LSF as binary step function
c0=2;
initialLSF=c0*ones(size(Img));
% generate the initial region R0 as a rectangle
initialLSF(5:size(Img,1)-5, 5:size(Img,2)-5)=-c0;  
phi=initialLSF;

if Display == 1
    figure(1);
    mesh(-phi);   % for a better view, the LSF is displayed upside down
    hold on;  contour(phi, [0,0], 'r','LineWidth',2);
    title('Initial level set function');
    view([-80 35]);

    figure(2);
    imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;  contour(phi, [0,0], 'r');
    title('Initial zero level contour');
    pause(0.5);
end

potential=2;  
if potential ==1
    potentialFunction = 'single-well';  % use single well potential p1(s)=0.5*(s-1)^2, which is good for region-based model 
elseif potential == 2
    potentialFunction = 'double-well';  % use double-well potential in Eq. (16), which is good for both edge and region based models
else
    potentialFunction = 'double-well';  % default choice of potential function
end

phi_pre = zeros(size(Img));
% start level set evolution
for n=1:iter_outer
    
    phi = drlse_edge(phi, g, lambda, mu, alfa, epsilon, timestep, iter_inner, potentialFunction);
    if max(max(abs(phi_pre - phi))) <= 0.35
        break
    end
    phi_pre = phi;
    if mod(n,2)==0 && Display==1
        figure(2);
        imshow(Img); axis off; axis equal; colormap(gray); hold on;  contour(phi, [0,0], 'r');
    end
    n/iter_outer
end

% refine the zero level contour by further level set evolution with alfa=0
alfa=0;
iter_refine = 10;
phi = drlse_edge(phi, g, lambda, mu, alfa, epsilon, timestep, iter_inner, potentialFunction);

finalLSF=phi;

if Display == 1
    figure(2);
    figure;imshow(Img2); axis off; axis equal; colormap(gray); hold on;  Contour = contour(phi, [0,0], 'r');
%     figure;imagesc(Img,[0,255]); axis off; axis equal; colormap(gray); hold on;  Contour = contour(phi, [0,0], 'r');
    hold on;  contour(phi, [0,0], 'r');
    str=['Final zero level contour, ', num2str(iter_outer*iter_inner+iter_refine), ' iterations'];
    title(str);

    pause(1);
    figure;
    mesh(-finalLSF); % for a better view, the LSF is displayed upside down
    hold on;  contour(phi, [0,0], 'r','LineWidth',2);
    str=['Final level set function, ', num2str(iter_outer*iter_inner+iter_refine), ' iterations'];
    title(str);
    axis on;
else
    figure;imshow(Img2); axis off; axis equal; colormap(gray); hold on; Contour = contour(phi, [0,0], 'r');
end


end