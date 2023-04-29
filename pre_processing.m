function img_out = pre_processing (img)
%median filter
[img,~] = median_filter(img, 9);


%Thresholding
gray_level = 255;
% img_scale= img*255;
x_his= histogram_cal(img,gray_level);
[wgz,wgz_min,T] =  Otsu_method(x_his);
img_out = threshold_image(img/gray_level, T,gray_level)/255;


img_out=1-img_out; %flip the image
se = strel('disk', 10);
img_out = imclose(img_out, se);

%img_out
end