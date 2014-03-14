

%JKR corrected the parameter order
function obj = setoutputdivider(obj, n, divsrc)

%SETOUTPUTDIVIDER  Sets an outputs divider value.
%  PLL=SETOUTPUTDIVIDER(OBJ, N, DIV) Sets output number N divider to DIV.
%
%  Copyright (c) 2005 Opal Kelly Incorporated
%  $Rev: 236 $ $Date: 2005-12-10 14:32:28 -0800 (Sat, 10 Dec 2005) $


% JKR edited a typo in this line
calllib('okFrontPanel', 'okPLL22393_SetOutputDivider', obj.ptr, n, divsrc);
