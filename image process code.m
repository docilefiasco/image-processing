function [signal,Ibw,stripes] = processImage(img)
% This function processes an image using the algorithm 
% developed using concepts learn in image processing course on mathworks
gs = im2gray(img);        %(converts image to grayscale)
gs = imadjust(gs);           %  (contrast)
H = fspecial("average",3);                % (creates a filter based on averaging the neighbor pixel intensities, thereby preventing random burst of colours and creates smooth binary image, 3 by 3)  
gssmooth = imfilter(gs,H,"replicate");      % (applies filter, replicate removes the black border due to automatic pixel value 0
SE = strel("disk",8);                      % (structure of disk with radius 8 is created to use in closing and opening)
Ibg = imclose(gssmooth, SE);                         %(closing first brightens the object then darkens it, removimg smaller draker objects like text)
Ibgsub = Ibg - gssmooth;                         %(this will remove bg from the original image as ibg is only bg. We subtracted in reverse order to prevent negative pixel values as darker values have lower rbg number)
Ibw = ~imbinarize(Ibgsub);                 % (makes negative to positive)
SE = strel("rectangle",[3 25]);             % (rectangular structure)
stripes = imopen(Ibw, SE);                % (highlights text, remove bg, it first darkens the image then brightens it, removing lighter smaller traces)
signal = sum(stripes,2);            %(adding up pixels of each row) //(doubt)
end

function isReceipt = classifyImage(I)
% This function processes an image using the algorithm developed in
% previous chapters and classifies the image as receipt or non-receipt
% Processing
gs = im2gray(I);
gs = imadjust(gs);
mask = fspecial("average",3);
gsSmooth = imfilter(gs,mask,"replicate");
SE = strel("disk",8); 
Ibg = imclose(gsSmooth, SE);
Ibgsub = Ibg - gsSmooth;
Ibw = ~imbinarize(Ibgsub);
SE = strel("rectangle",[3 25]);
stripes = imopen(Ibw, SE);
signal = sum(stripes,2); 

% Classification
minIndices = islocalmin(signal,"MinProminence",70,"ProminenceWindow",25); 
Nmin = nnz(minIndices);
isReceipt = Nmin >= 9;
%(here, we are counting dark minimas which will be more if there are black texts just like there is in a receipt)
%(processing is required to remove errors during classification)
