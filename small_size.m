cond = [1e2, 1e3, 1e4, 1e5, 1e6, 1e7, 1e8, 1e9];
matrices = cell(size(cond,2));
for i=1:size(cond,2)
    matrices{i} = genMatrix(500, cond(i));
end

relresgm = zeros(size(matrices,2),1);
relreslu = zeros(size(matrices,2),1);
itergm = zeros(size(matrices,2),1);
iterlu = zeros(size(matrices,2),1);
timegm = zeros(size(matrices,2),1);
timelu = zeros(size(matrices,2),1);

for i = 1:size(matrices,2)
    b = rand(size(matrices{i},1),1);
    tic
    [x, flag, relres, iter] = gmres(matrices{i}, b, [], 1e-6, 30);
    timegm(i) = toc;
    relresgm(i) = relres;
    flags(i) = flag;
    itergm(i) = iter(2);

    tic
    [x, relres, iter] = iterref(matrices{i}, b);
    timelu(i) = toc;
    relreslu(i) = relres(size(relres,2));
    iterlu(i) = iter;
end

figure(1)
loglog(cond, relreslu);
title("luir: Relative Residual vs Condition Number (n = 500)")
xlabel("Condition Number")
ylabel("Relative Residual")
saveas(gcf,'luir_acc_smat.png')
figure(2)
loglog(cond, relresgm);
title("gmres: Relative Residual vs Condition Number (n = 500)")
xlabel("Condition Number")
ylabel("Relative Residual")
saveas(gcf,'gmres_acc_smat.png')

figure(3)
semilogx(cond, iterlu, cond, itergm);
title("Iterations vs Condition Number (n = 500)")
xlabel("Condition Number")
ylabel("Number of Iterations")
legend("luir", "gmres")
saveas(gcf,'iter_smat.png')

figure(4)
semilogx(cond, timelu, cond, timegm);
title("Time vs Condition Number (n = 500)")
xlabel("Condition Number")
ylabel("Time (seconds)")
legend("luir", "gmres")
saveas(gcf,'time_smat.png')

