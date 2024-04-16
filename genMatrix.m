function A = genMatrix(size, cond)
    A = 2*rand(size);
    [u, s, v] = svd(A);
    s = diag(s);
    s = s(1)*( 1-((cond-1)/cond)*(s(1)-s)/(s(1)-s(end))) ;
    s = diag(s);
    A = u*s*v';
end