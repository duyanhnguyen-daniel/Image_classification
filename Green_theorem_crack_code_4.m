% Load binary image
clc
 im_0 = imread('5_Screw_6.bmp');
 if size(im_0,3) == 3  % RGB image
    % Convert RGB image to grayscale using the rgb2gray function
    im_0 = rgb2gray(im_0);
end
 imshow(im_0)
 im = im2gray(im_0);
 level = graythresh(im);
BW = imbinarize(im,level);
im_0=1-BW; %flip the image
se = strel('disk', 10);
im_0 = imclose(im_0, se);
imshowpair(1-BW,im_0,'montage')
im=im_0;
%  im = im2bw(im); % Convert to binary


% im = [0 1 1 1 0 0 0 0;
%     0 1 1 0 0 0 0 0;
%     0 1 1 0 0 0 0 0;
%     0 1 1 0 0 0 0 0;
%     1 1 1 0 0 0 0 0;
%     1 1 1 0 0 0 0 0;
%     0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0;
%     ];
im = [0 1 1 1;
     0   1 0 1;
     0  1  1 1];

imshow(im)

im_rows = size(im, 1);
im_cols = size(im, 2);

% Define neighbor offsets for 4-connectivity
offsets = [-1 0; 0 -1; 1 0; 0 1]; %basde on code 0 1 2 3

% Find starting pixel P
for rowP=1: im_rows
    for colP=1: im_cols
        if im(rowP,colP) ==1
            disp('break1');
            break;
        end
    end
    if im(rowP,colP) ==1
        disp('break2');
        break;
    end

end



%Back ground padding:

% Define the desired padding
pad_size = 1;

% Create a new matrix with the desired padded size
padded_img = zeros(im_rows + 2*pad_size, im_cols + 2*pad_size);

% Copy the original image to the center of the padded image
padded_img(pad_size+1:im_rows+pad_size, pad_size+1:im_cols+pad_size) = im;

im = padded_img;

rowP= rowP+pad_size; %shift as padding
colP= colP+pad_size;

rowP0=rowP;
colP0=colP;
% Initialize crack code
crack_code = [];


% Find a background pixel Q neighboring P
for i = 2:size(offsets, 1) % we eliminate code 0 at the beginning
    rowQ = rowP + offsets(i, 1);
    colQ = colP + offsets(i, 2);
    if ~im(rowQ, colQ)
        break;
    end
end

crack_code = i-1; %adjusting the index
% Main loop
x=colP;
y=rowP;

m00=0; m20=0;
m01=0; m10=0;
m02=0; m11=0;
sum_x=0; sum_x2=0;
sum_y=0; sum_y2=0;

while true

    % Calculate U and V pixels  and moments   x: col, y: row
    switch crack_code(end)
        case 0 %  Code 0
            rowU = rowP; colU = colP - 1;
            rowV = rowP-1;     colV = colP - 1;

           m00 = m00 - y;
	m01 = m01 - sum_y;
	m02 = m02 - sum_y2;
	x = x - 1;
	sum_x = sum_x - x;
	sum_x2 = sum_x2 - x*x;
	m11 = m11 - (x*sum_y);


        case 1 % Code 1
            rowU = rowP+1;     colU = colP ;
            rowV = rowP + 1; colV = colP - 1;

      sum_y = sum_y + y;
	sum_y2 = sum_y2 + y*y;
	y = y + 1;
	m10 = m10 - sum_x;
	m20 = m20 - sum_x2;




        case 2 % Code 2
            rowU = rowP ; colU = colP + 1;
            rowV = rowP + 1; colV = colP+1;

           m00 = m00 + y;
	m01 = m01 + sum_y;
	m02 = m02 + sum_y2;
	m11 = m11 + (x*sum_y);
	sum_x = sum_x + x;
	sum_x2 = sum_x2 + x*x;
	x = x + 1;



        case 3 % Code 3
            rowU = rowP - 1; colU = colP;
            rowV = rowP - 1; colV = colP + 1;

            y = y - 1;
	sum_y = sum_y - y;
	sum_y2 = sum_y2 - y*y;
	m10 = m10 + sum_x;
	m20 = m20 + sum_x2;



    end

    % Calculate next crack code and P-pixel by checking the image at pixel U&V
    if im(rowV, colV)
        crack_code(end+1) = mod(crack_code(end)-1,4);
        rowP = rowV; colP=colV;
    else
        if im(rowU, colU)
            crack_code(end+1) = crack_code(end);
            rowP = rowU; colP=colU;
            rowQ = rowV; colQ=colV;
        else
            crack_code(end+1) = mod(crack_code(end)+1,4);
            rowQ = rowU; colQ=colU;
        end
    end



    %Stop condition and remove the last crack code

    if (rowP==rowP0) && (colP==colP0) &&  (crack_code(end)== crack_code(1))
        crack_code = crack_code(1:end-1);
        break
    end


    % Move to next pixel
end


%% calculate number of holes, several moment invariants, complexity/circularity

%Calculate parameter:
P=length(crack_code);
% complexity:
C= P^2/m00;
C
P
Ci=4*pi*m00/(P^2)
disp("Area:")
m00
% Display results
%disp(crack_code);