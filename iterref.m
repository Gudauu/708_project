function [x, relres, itcount] = iterref(A,b)
% Solves A*x=b using Gauss elimination and iterative refinement.
% A is a dense, n-by-n double precision matrix and b is an n double
% precision vector.
% The LU factorization of A is computed in single precision and the first
% approximate solution x1 is computed in single precision.
% The residual is evaluated in double precision, and the corrected solution
% is in double precision.
%  x contains the computed solution
%  relres(i) contains norm(b-A*x)/norm(b) for the i-th iteration

[n,~] = size(A);

% to accumulate solution
x = zeros(n,1);

% LU decompoisition
[L, U, P] = lu(single(A),'vector');
opts.LT = true;
opts2.UT = true;

% store b in single precision
r = single(b);

tol = 10*eps;
itcount = 1;
rnorm = norm(r);
bnorm = rnorm;
rnormold = 2*rnorm;
while itcount <= 30 && rnorm>tol*bnorm && rnorm < 0.9*rnormold
  y = linsolve(L, r(P), opts);
  r = linsolve(U, y, opts2);
  x = double(x)+double(r);
  r = b-A*x;
  rnorm = norm(r);
  relres(itcount) = rnorm;  
  itcount = itcount +1;
end
end