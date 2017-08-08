function [X err1 err2 of] = IST(D, Y,n, err, insweep, tol, decfac)

alpha = max(eig(D'*D));
% for restricted fourier type of H, alpha > 1;
err1=[];
err2=[];
of=[];


if nargin < 4
    err = 1e-8;
end
if nargin < 5
    insweep =n;
end
if nargin < 6
    tol = 1e-8;    
end
if nargin < 7
    decfac = 0.009;
end

%alpha = 0.01;

sizeX = size(D'*Y);
X = zeros(sizeX);

lambdaInit = decfac*max(max(abs(D'*Y))); 
lambda = lambdaInit;%1e3;
aa=lambdaInit*tol;
f_current = norm(Y-D*X,'fro') + lambda*norm(X(:),1);

while lambda >lambdaInit*tol %1e-9
     % lambda
    for ins = 1:insweep
        f_previous = f_current;
        
        %B= lsqnonneg(D,Y);
        B = X + (D'*(Y-D*X))/alpha;
        x = SoftTh(B(:), lambda/(2*alpha));
        X = reshape(x,sizeX);
        
        f_current =norm(Y-D*X,'fro') + lambda*norm(X(:),1);
        
        if norm(f_current-f_previous)/norm(f_current + f_previous)<tol
            break;
        end
        
        err2=[err2 norm(Y-D*X,'fro')];
    
    err1=[err1 norm(X(:),1)];
    
    of=[of f_current];
    end
    
    
    if norm(Y-D*X,'fro')<err
        break;
    end
    lambda = decfac*lambda;
end


    function  z = SoftTh(s,thld)
        z = sign(s).*max(0,abs(s)-thld); 
    end
end