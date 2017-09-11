% Shobha Sundar Ram
% 15th July 2017
% Indraprastha Institute of Information Technology Delhi
% Disaggregation algorithm to figure out the right combination of
% appliances using both smart meter data and EMI data

function [Appliance_Combo_output,Energy_Consumed_output,Error_output]=Disaggregation_FUNC(K_input,Emeas_input,tol_input)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % INPUT ARGUMENTS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % {K_input} - This is the set of class labels that have been identified 
    % with the data from the EMI sensor
    
    % Emeas_input - This is the measured power obtained from the smart meter
    
    % tol_input - The combination of appliances must consume a power that
    % is within the specified tolerance with respect to the measured power
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % OUTPUT ARGUMENTS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Appliance_Combo_output - This is the set of appliance combinations with
    % their counts that have identified as potential solution to the
    % disaggregation algorithm
    
    % Energy_Consumed_output - This is the energy consumed by each of these
    % combinations
    
    % Error_output - This is the error between their energy consumed and
    % the measured energy
    
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
%     size(A_Perm)
%     A_Perm
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Energy consumed by each combination
    % Error is computed for each combination based on the measured energy
    % provided by the smart meter. 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Energy_Perm = zeros(numPerm,1);
    error_Perm = zeros(numPerm,1);
    for n = 1:numPerm
        Energy_Perm(n) = sum(A_Perm(n,:).*EnergyK);
        error_Perm(n) = abs(Emeas_input-Energy_Perm(n))/Emeas_input;
    end
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The appliance combination is identified if it is within the
    % stipulated error tolerance
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Disaggregation output based on error being below the specified
    % tolerance
    [minInd] = find(error_Perm<=tol_input);
    if length(minInd) < 1
%         disp('Disaggregation has failed for the specified tolerance limits');
        Appliance_Combo_output = 0;
        Energy_Consumed_output= 0;
        Error_output = 100;
    else
        Appliance_Combo_output = A_Perm(minInd,:);
        Energy_Consumed_output= Energy_Perm(minInd,:);
        Error_output = error_Perm(minInd,:)*100;
    end
end
