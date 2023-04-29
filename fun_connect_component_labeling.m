
function labels= fun_connect_component_labeling(bw)


% This function performs connected component labeling on a binary image using
% two-pass algorithm. Each object is assigned a unique label, and objects that
% are connected are assigned the same label.
%
% Inputs:
% - bw: binary image (logical or numeric)
%
% Outputs:
% - labels: labeled image (numeric)

%%
bw_rows = size(bw, 1);
bw_cols = size(bw, 2);
labels = zeros(bw_rows, bw_cols);
label_no=0;
% First pass to assign labels
for row = 1:bw_rows
    for col = 1:bw_cols
        p = bw(row, col);
        if p == 0
            continue
        end

        top = 0;
        left = 0;
        top_lb = 0;
        left_lb = 0;

        if row > 1
            top = bw(row-1, col);
            top_lb = labels(row-1, col);
        end

        if col > 1
            left = bw(row, col-1);
            left_lb = labels(row, col-1);
        end

        if top == 0 && left == 0
            label_no = label_no + 1;
            labels(row, col) = label_no;

        elseif top == 0 || left == 0
            labels(row, col) = max(top_lb, left_lb);

        elseif top_lb == left_lb
            labels(row, col) = top_lb;

        else
            labels(row, col) = left_lb;
            % Update equivalence pairs
            labels(labels == top_lb) = left_lb;
        end
    end
end
%%
% 
% % Count the number of unique labels (excluding the background label 0)
% num_objects = length(unique(labels)) - 1;
% 
% % Display the labeled image
% color_labels = label2rgb(labels, 'jet', 'k', 'shuffle');
% 
% imshow(color_labels);
% 
% areas = zeros(length(A), 1);
% A= unique(labels);
% 
% hold on;
% for i = 2:length(A)
%     % Compute the actual area of object i
% 
%     areas(i) = sum(labels(:) == A(i));
% 
%     % Compute the centroid of object i
%     [rows, cols] = find(labels == A(i));
%     centroids(i, :) = mean([cols,rows]);
%     
% plot(centroids(i,1), centroids(i,2),'r*');
%     text(centroids(i,1), centroids(i,2), num2str(areas(i)), 'Color', 'red');
% 
% end
% 
