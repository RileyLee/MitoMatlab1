function imageMargin = AddMargin(image, margin, padding)

  % padding   0 --- Zero margin;   1 --- Mirror margin;   2 -- Repeating

  H = size(image, 1);
  W = size(image, 2);
  C = size(image, 3);

  H_margin = H + margin * 2;
  W_margin = W + margin * 2;

  imageMargin = zeros(H_margin, W_margin, C);
  imageMargin(margin+1: margin+H, margin+1:margin+W, :) = image;

  if padding ==0
    imageMargin(:, 1:margin, :) = 0;
    imageMargin(:, (W_margin-margin+1):W_margin, :) = 0;
    imageMargin(1:margin, :, :) = 0;
    imageMargin((H_margin-margin+1):H_margin, :, :) = 0;


  elseif padding == 1
    imageMargin(:, 1:margin, :) = flipdim(imageMargin(:,(margin+1):(2*margin),:),2);
    imageMargin(:, (W_margin-margin+1):W_margin, :) = flipdim(imageMargin(:, (W_margin-2*margin+1):W_margin-margin, :), 2);
    imageMargin(1:margin, :, :) = flipdim(imageMargin((margin+1):(2*margin), :, :), 1);
    imageMargin((H_margin-margin+1):H_margin, :, :) = flipdim(imageMargin((H_margin-2*margin+1):H_margin-margin, :, :), 1);


  elseif padding == 2
    imageMargin(:, 1:margin, :) = repmat(imageMargin(:, margin+1, :), [1, margin, 1]);
    imageMargin(:, (W_margin-margin+1):W_margin, :) = repmat(imageMargin(:, W_margin-margin, :), [1, margin, 1]);
    imageMargin(1:margin, :, :) = repmat(imageMargin(margin+1, :, :), [margin, 1, 1]);
    imageMargin((H_margin-margin+1):H_margin, :, :) = repmat(imageMargin(H_margin-margin, :, :), [margin, 1, 1]);

  end


  return
