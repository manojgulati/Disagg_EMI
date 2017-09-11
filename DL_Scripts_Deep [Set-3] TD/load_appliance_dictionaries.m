function [D_CFL D_LCD_CPU D_LC D_PRJ D_PRT D_MFD D_BGN Dictionary]= load_appliance_dictionaries(str)

% close all;
% clear all;
clc;

Path1 = str;

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Load class specific dictionaries                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% load dictionary for CFL
load (strcat('CFL',Path1));
D_CFL=Dict;
clear Dict; clear J; clear Z;

% load dictionary for CPU
load (strcat('CPU',Path1));
D_LCD_CPU=Dict;
clear Dict; clear J; clear Z;

% load dictionary for LC
load (strcat('LC',Path1));
D_LC=Dict;
clear Dict; clear J; clear Z;

% load dictionary for PRJ
load (strcat('PRJ',Path1));
D_PRJ=Dict;
clear Dict; clear J; clear Z;

% load dictionary for PRT
load (strcat('PRT',Path1));
D_PRT=Dict;
clear Dict; clear J; clear Z;

% load dictionary for MFD
load (strcat('MFD',Path1));
D_MFD=Dict;
clear Dict; clear J; clear Z;

% load dictionary for BGN
load (strcat('BGN',Path1));
D_BGN=Dict;
clear Dict; clear J; clear Z;

% % concatenating dictionaries
Dictionary=[D_CFL D_LCD_CPU D_LC D_PRJ D_PRT D_MFD D_BGN];

end
