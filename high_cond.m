sizes = [10,100,500,1000, 5000];
matrices = cell(size(sizes,2));
for i=1:size(sizes,2)
    matrices{i} = genMatrix(sizes(i), 1e9);
end

relresgm = zeros(size(matrices,2),1);
relreslu = zeros(size(matrices,2),1);
itergm = zeros(size(matrices,2),1);
iterlu = zeros(size(matrices,2),1);
timegm = zeros(size(matrices,2),1);
timelu = zeros(size(matrices,2),1);
flags = zeros(size(matrices,2),1);

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
semilogy(sizes, relreslu);
title("luir: Relative Residual vs Matrix Size (condition = 1e9)")
xlabel("Matrix Size")
ylabel("Relative Residual")
saveas(gcf,'luir_acc_hcond.png')
figure(2)
semilogy(sizes, relresgm);
title("gmres: Relative Residual vs Matrix Size (condition = 1e9)")
xlabel("Matrix Size")
ylabel("Relative Residual")
saveas(gcf,'gmres_acc_hcond.png')

figure(3)
plot(sizes, iterlu, sizes, itergm);
title("Iterations vs Matrix Size (condition = 1e9)")
xlabel("Matrix Size")
ylabel("Number of Iterations")
legend("luir", "gmres")
saveas(gcf,'iter_hcond.png')

figure(4)
plot(sizes, timelu, sizes, timegm);
title("Time vs Matrix Size (condition = 1e9)")
xlabel("Matrix Size")
ylabel("Time (seconds)")
legend("luir", "gmres")
saveas(gcf,'time_hcond.png')

