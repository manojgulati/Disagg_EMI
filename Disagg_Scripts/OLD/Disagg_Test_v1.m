clc;
clear all;
close all;

C = [1 2 3 4 5 6];

nC = [3, 2, 2, 1, 2, 1];

pC = [18, 75, 50, 300, 400, 450];


Pow_Vect = 18 + (2)*rand(3000,1);
n_tcases = 1; % Ideally 3000 samples per test case

% Load Class Labels for Test Case-1
load('Class_labels_CFL_T5');

for i = 1:n_tcases

    
end

%%
fun = @(x)norm(18*x(1)+75*x(2)+50*x(3)+300*x(4)+400*x(5)+450*x(6) - 20);

lb = zeros(6,1); % Min. number of appliance instances that are possible for each AUT
ub = nC; % Upper bound is defined by max number of instances possible for each AUT

A = [];
b = [];
Aeq = [];
beq = [];

x0 = [1,0,1,0,0,0];
x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub)








