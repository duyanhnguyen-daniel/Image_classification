
% Load binary image
im = imread('Lock.bmp');
%im = im2bw(im); % Convert to binary
im=im2gray(im);
level = graythresh(im)
BW  = imbinarize(im,level);
imshowpair(im,BW,'montage')


% Initialize variables
[height, width] = size(im);
boundary_pixels = [];

% Define neighbor offsets for 4-connectivity
offsets = [-1 0; 1 0; 0 -1; 0 1];

% Iterate over each pixel in the image
for row = 1:height
    for col = 1:width
        % If pixel is foreground and has at least one background neighbor
        if im(row, col) & any(im(max(1,row+offsets(:,1)), max(1,col+offsets(:,2))) == 0)
            % Add boundary pixel to list
            boundary_pixels(end+1,:) = [row col];
        end
    end
end

% Display results
figure;
imshow(im);
hold on;
plot(boundary_pixels(:,2), boundary_pixels(:,1), 'r.');