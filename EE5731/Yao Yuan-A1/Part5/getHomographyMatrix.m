%% get the Homography Matrix from mat1 to mat2
function h = getHomographyMatrix(mat1, mat2)
    % mat1 2*num
    point_nums = size(mat1,2);
    A = zeros(2*point_nums,9);
    row = 1;
    for i = 1:point_nums
        x1 = mat1(1,i);
        y1 = mat1(2,i);
        x2 = mat2(1,i);
        y2 = mat2(2,i);
        A(row,:) = [x1, y1, 1, 0, 0, 0, -x2*x1, -y1*x2, -x2];
        A(row+1,:) = [0, 0, 0, x1, y1, 1, -x1*y2, -y1*y2, -y2];
        row = row + 2;
    end

    [U , S, V] = svd(A);
    % h is the last row of V'
    Vt = V';
    h = Vt(end, :);
    h = reshape(h, [3,3])';
end