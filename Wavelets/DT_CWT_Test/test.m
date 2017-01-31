  %Decimated Version 0 (full decimation)  
  x = uint8(imread('87.tif'));
  x = x(:,:,1:3);
  x = rgb2gray(x);
  x1 = ones(128,128)* double(x(1,1));
  x1(1:size(x,1),1:size(x,2)) = x;
  x = x1;
  J = 2;
  [Faf, Fsf] = AntonB;
  [af, sf] = dualfilt1;
  w = NDxWav2DMEX(x, J, Faf, af,0);
  figure;
  
  for k = 1:2
      for j = 1:3
          for i = 1:2
              t = w{k}{1}{i}{j};
              count1 = i*3 + j - 3;
              count2 = count1 + k*6 - 6;
              subplot(2,6,count2);imagesc(t);colormap(gray)
          end
      end
  end
  

