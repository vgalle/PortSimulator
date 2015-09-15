function Mins_row = mins_of_row (row_config,Number_cont_block)

% Last Modification: 2/2
% Setareh

global Maxzone

% Maxzone should be defined as global
row_config_temp = row_config;


row_config_temp(row_config_temp==0)=Number_cont_block + Maxzone + 1;
Mins_row = min(row_config_temp)';
