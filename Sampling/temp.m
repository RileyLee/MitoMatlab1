Image = A03_02(1201:2000, 1:800, :);
Ave = imread('Ave.png');
prop = imread('proposal.png');
seg = imread('seg_pix.png');

cform = makecform('srgb2xyz');
xyz = applycform(Image, cform);
cform = makecform('xyz2uvl');
luv = applycform(xyz, cform);

[Gmag, Gdir] = imgradient(Image(:,:,3));

imwrite(Image, 'ori.png');
imwrite(luv, 'luv.png');

imagesc(Gmag); colormap(gray)
set(gca,'XTick',[])
set(gca,'YTick',[])
set(gca,'Position',[0 0 1 1])
saveas(gcf, 'Gmag', 'png')

imagesc(Gdir); colormap(gray)
set(gca,'XTick',[])
set(gca,'YTick',[])
set(gca,'Position',[0 0 1 1])
saveas(gcf, 'Gdir', 'png')

imwrite(Ave(1201:2000, 1:800, :), 'ave.png');
imwrite(prop(1201:2000, 1:800, :), 'prop.png');
imwrite(seg(1201:2000, 1:800, :), 'seg.png');
