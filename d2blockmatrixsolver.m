
% create a tridiagonal matrix
n = 3;
sides = ones(n - 1, 1);
mid = -2 .* ones(n, 1);
T = gallery('tridiag', sides, mid, sides);

% identity matrix
I = eye(n);

% combine for the full d2 block matrix 
a = kron(I,T);
b = kron(T,I);
d2block = a +b;

% get random b values for testing
disp('Random b values:')
bvalues = randi([1 n^2], n^2, 1)
A = [d2block bvalues];

% fix lower right half of A matrix to row echelon form
for col = 1: n^2
    div = A(col, col);
    A(col, :) = A(col, :) ./ div;
    if col ~= n^2
        for row = col+1 : n^2
            A(row,:) = A(row, :) - (A(row, col) .* A(col, :));
        end
    end
end

% fix upper right half of A matrix to ro echelon form
for col = n^2 : -1 : 2
    for row = col - 1 : -1 : 1
        A(row,:) = A(row, :) - (A(row, col) .* A(col, :));
    end
end

disp('Solved for b values');
disp(A);

% test using rref
disp('b values found using MATLAB rref function');
disp(rref(A));

% test using backslash linear solver
disp('b values found using MATLAB backslash linear solver');
disp(d2block \ bvalues);