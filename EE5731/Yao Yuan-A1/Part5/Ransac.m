%% RanSac algorithm
function [best_mat1,best_mat2,best_h,best_inliners] = Ransac(match_point1,match_point2)
    % RANSAC parameters
    best_inliners = [];
    best_inlinercount = 0;
    threshold = 10;
    iter = 100000;
    disp(['RANSAC with threshold = ',num2str(threshold),' iterations = ',num2str(iter)]);

    for k = 1:iter
        % random choose 5 match points 
        idx = randperm(size(match_point1,1),5);
        mat1 = match_point1(idx,:);
        mat1 = mat1';
        mat2 = match_point2(idx,:);
        mat2 = mat2';
        h = getHomographyMatrix(mat1, mat2);
        inliner_count = 0;
        for j=1:size(match_point1,1)
            homo_input = [match_point1(j,:) 1]'; % 3*1
            output = h * homo_input;
            homo_output(1:3,:) = output(:,:)./output(3,:);
            norm1 = norm([match_point2(j,:) 1]'-homo_output);
            if norm1 < threshold
                inliner_count = inliner_count + 1;
            end
        end
        % best inline count will correspond to best homography matrix
        if inliner_count > best_inlinercount
            best_mat1 = mat1;
            best_mat2 = mat2;
            best_inlinercount = inliner_count;
            best_h = h;
        end
    end
    for j=1:size(match_point1,1)
        homo_input = [match_point1(j,:) 1]'; % 3*1
        output = best_h * homo_input;
        homo_output(1:3,:) = output(:,:)./output(3,:);
        norm1 = norm([match_point2(j,:) 1]'-homo_output);
        if norm1 < threshold
            best_inliners = [best_inliners j];
        end
    end
end