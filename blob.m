% Load binary imagFasteners_1.bmp
im = imread('Fasteners_1.bmp');
if size(im,3) == 3  % RGB image
    % Convert RGB image to grayscale using the rgb2gray function
    im = rgb2gray(im);
end
level = graythresh(im);
BW = imbinarize(im,level);

% im = im2bw(im); % Convert to binary
im_0=1-BW; %flip the image
%im_0=BW;
se = strel('disk', 10);
im_0 = imclose(im_0, se);
imshowpair(1-BW,im_0,'montage')

im=im_0;


% Initialize variables
[height, width] = size(im);
visited = false(height, width);
blobs = struct('centroid', [], 'area', []);

% Define neighbor offsets for border following
offsets = [-1 0; 1 0; 0 -1; 0 1];

% Perform blob analysis
for row = 1:height
    for col = 1:width
        % If pixel is part of a new blob
        if im(row, col) && ~visited(row, col)
            blob_pixels = zeros(height, width);
            blob_pixels(row, col) = 1;
            visited(row, col) = true;
            area = 1;
            perimeter = 0;
            queue = [row col];
            
            % Follow border of blob
            while ~isempty(queue)
                curr = queue(1,:);
                queue(1,:) = [];
                for i = 1:size(offsets,1)
                    next = curr + offsets(i,:);
                    if next(1) < 1 || next(1) > height || next(2) < 1 || next(2) > width
                        continue; % Out of bounds
                    end
                    if im(next(1), next(2)) && ~visited(next(1), next(2))
                        visited(next(1), next(2)) = true;
                        blob_pixels(next(1), next(2)) = 1;
                        area = area + 1;
                        queue(end+1,:) = next;
                    else
                        if ~im(next(1), next(2))
                            perimeter = perimeter + 1;
                        end
                    end
                end
            end
            
            % Calculate blob properties
            [rows, cols] = find(blob_pixels);
            centroid = [mean(cols) mean(rows)];
            blobs(end+1).centroid = centroid;
            blobs(end).area = area;
            blobs(end).perimeter = perimeter;
        end
    end
end

% Display results
figure;
imshow(im);
hold on;
for i = 2:length(blobs)
    plot(blobs(i).centroid(1), blobs(i).centroid(2), 'r*');
    text(blobs(i).centroid(1), blobs(i).centroid(2), num2str(blobs(i).area), 'Color', 'red');
end

no_obj= length(blobs)-1