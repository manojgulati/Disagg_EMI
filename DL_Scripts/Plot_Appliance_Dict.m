clc;
clear all;
close all;

File_Names = {'BGN1','CFL1','CPU1','LC1','LCD1','PRJ1','PS1'};

index = 0;

Dict_Data = [];
Z_Data = [];
J_Data = [];

for index=1:7
    %load data samples 
    load(strcat(char(File_Names(index)),'_DL_Data.mat'));
    Dict_Data = [Dict_Data, Dict];
    Z_Data = [Z_Data, Z];
    J_Data = [J_Data, J];
end

%% Data matrix
Offset=0;
for index = 1:7
    figure;
    imagesc(Dict_Data(:,1+Offset:1000+Offset))
    colorbar;
%     caxis([-0.017 0.18]);
    xlabel('Number of atoms');
%     Save figures
%     saveas(gcf,strcat(char(File_Names(index)),'_Dict_1024x1000','.png'));
%     close all;
    
    Offset=Offset+1000;
end
    
%%    
%signal reconstruction to check the acuracy of the dictionary learnt 
signal_rec=Dict_human*Z_human;

%normalised mean square error between original signal and reconstructed using dictionary
nmse=norm((-signal_rec+signal_human_data),'fro')/norm(signal_human_data,'fro')*100;

