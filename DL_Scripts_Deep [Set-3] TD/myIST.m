function X = myIST(D, Y,n,lambda)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Y:Training data matrix                                                                %
%   D:Dictionary                                                                          %
%   n:Number of iterations                                                                %
%  lambda: regularisation parameter that controls sparsity level and signal reconstruction 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha = max(svd(D)).^2;

sizeX = size(D'*Y);
X = zeros(sizeX);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     ISTA implemented                                    %
%                 J(D,Z)=||Y-DX||2 +|Z|1                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f_current = norm(Y-D*X,'fro') + lambda*norm(X(:),1);
    
    for ins = 1:n
        f_previous = f_current;
         B = X + (D'*(Y-D*X))/alpha;
        x = SoftTh(B(:), lambda/(2*alpha));
        X = reshape(x,sizeX);
        
        f_current = norm(Y-D*X,'fro') + lambda*norm(X(:),1);                
    end   
end

% soft thresholding function (picks only coefficient lying within threshold others are made zero)
    function  z = SoftTh(s,thld)
        z = sign(s).*max(0,abs(s)-thld); 
    end

