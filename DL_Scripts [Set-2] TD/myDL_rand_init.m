function [D,Z,J]=myDL_rand_init(X,n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        X: Training data matrix                          %
%                        n: numbe rof dictionary atoms                    %   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                           

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %        for less number of atoms than number of data samples (n<t)     %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  
% % %initialize dictionary
% t=(size(X,2));
% index=randperm(t);
% D=X(:,index(1:n));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             for more number of atoms than numbe rof smaples (n>t)       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%dictionary intialzation atoms randomly from given data samples
t=(size(X,2));  % number of data samples
iter=ceil(n/t); 
for i=1:iter
    index=randperm(t);
    temp1(:,[1:t]+t*(i-1))=X(:,index);
end
D=temp1(:,1:n); 

% number of iterations
Max_N_it=100; % % Earlier it was 10 
N_it=1;      
J=[];

% regularisation parameter
lambda=.001;  
lambda1=0;

% objective function intilisation
Jnow        =   50;
Jpre        =   0;

% loop until following criterion is satisfied (objective function reaches certain tolerance level or till maximum number of iterations)
while abs(Jnow-Jpre)>1e-5 && N_it < Max_N_it

% sparse coding (l1 minimisation)--------------step1 for dictionary learning
Z=IST(D,X,20);

% ridge regression (to avoid overfitting problem)
Z_t=[Z,sqrt(lambda1)*eye(size(Z,1))];
X_t=[X,zeros(size(X,1),size(Z_t,2)-size(X,2))]; 
A=Z_t*Z_t';
B=X_t*Z_t';

% least squares --------------step2 for updating dictionary
D=B*pinv(A);

% normalising coloumns of dictionary
D=D*diag(1./sqrt(sum(D.*D)));

% check for the convergence of objective function
Jpre =Jnow;
Jnow=norm(X_t-D*Z_t,'fro') + lambda*norm(Z_t,1)+lambda1*norm(D,'fro')
%  Jnow=norm(X-D*Z,'fro')^2 + lambda*norm(Z(:),1)
J=[J (Jnow)'];
N_it = N_it+1;
end


