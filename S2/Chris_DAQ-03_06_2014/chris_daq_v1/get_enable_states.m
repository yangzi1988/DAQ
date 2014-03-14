% Obtains the enable states
function [cs cf rs su] = get_enable_states(handles)
% Cslow
cs = get(handles.enable_comp_cslow,'Value');

% Cfast
cf = get(handles.enable_comp_cfast,'Value');

% Reseries
rs = get(handles.enable_comp_rseries,'Value');

% Supercharge
su = get(handles.enable_comp_supercharge,'Value');

