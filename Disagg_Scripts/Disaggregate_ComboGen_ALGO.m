% Shobha Sundar Ram
% Indraprastha Institute of Information Technology Delhi
% August 22 2017
% Generating all the possible disaggregated results combinations

K_input = [1:6];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD APPLIANCE INFORMATION
% This is a structure that saves the appliance class labels, the maximum
% possible number of appliances for every class and the average energy
% consumed by that class
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = load('Appliance_Info');
nK = length(K_input);
% Number of possible elements in each class
numK = s.Appliance_STRUCT.App_Num(K_input);
% Energy for each label
EnergyK = s.Appliance_STRUCT.App_Energy(K_input);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD APPLIANCE INFORMATION
% This is a structure that saves the appliance class labels, the maximum
% possible number of appliances for every class and the average energy
% consumed by that class
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Products

ProductsK = ones(1,length(K_input));
Product =1 ;
for k = nK:-1:2
    Product = Product*(numK(k)+1);  
    ProductsK(k-1) = Product;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The maximum possible permutations of appliance combinations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Number of permutations to consider
numPerm = 1;
for i = 1:nK
    numPerm = numPerm*(numK(i)+1);
end
% Possible Combinations
A_Perm = zeros(numPerm,nK);
iK = zeros(1,nK);
for n = 1:numPerm
    for k = 1:nK
        A_Perm(n,k) = iK(k);
        if rem(n,ProductsK(k)) == 0
            iK(k) = iK(k)+1;
            if iK(k) == numK(k)+1
                iK(k) = 0;
            end
        end
    end
end

save Disaggregate_Cat A_Perm numPerm;
