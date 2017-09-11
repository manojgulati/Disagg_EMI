
clc;
clear all;

load('CFL_FFT_Dump');

%%

X = M1(1:525,:);


%%

n = 100; %dictionary atoms
t=(size(X,2));  % number of data samples
iter=ceil(n/t); 
for i=1:iter
    index=randperm(t);
    temp1(:,[1:t]+t*(i-1))=X(:,index);
end
D=temp1(:,1:n);

n_iter=100;
Y = X;

D_Test = myIST(D, Y,n_iter,0.1);