function [ image ] = markPrediction( image, x, y )
    r = size(image, 1);
    c = size(image, 2);
    
    x1 = max(x - 50, 1);
    x2 = max(x - 45, 1);
    y1 = max(y - 50, 1);
    y2 = min(y + 50, c);
    image(x1:x2, y1:y2, 1:2) = 255;
    image(x1:x2, y1:y2, 3) = 0;
    
    x1 = min(x + 45, r);
    x2 = min(x + 50, r);
    y1 = max(y - 50, 1);
    y2 = min(y + 50, c);
    image(x1:x2, y1:y2, 1:2) = 255;
    image(x1:x2, y1:y2, 3) = 0;
    
    x1 = max(x - 50, 1);
    x2 = min(x + 50, r);
    y1 = max(y - 50, 1);
    y2 = max(y - 45, 1);
    image(x1:x2, y1:y2, 1:2) = 255;
    image(x1:x2, y1:y2, 3) = 0;
    
    
    
    
    x1 = max(x - 50, 1);
    x2 = min(x + 50, r);
    y1 = min(y + 45, c);
    y2 = min(y + 50, c);
    image(x1:x2, y1:y2, 1:2) = 255;
    image(x1:x2, y1:y2, 3) = 0;
end

