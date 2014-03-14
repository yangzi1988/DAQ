

% JKR edited this file to add the 'enable' parameter



function obj = setpllparameters(obj, n, p, q, en)

%SETPLLPARAMETERS  Sets the P and Q values for the specified PLL.
%  OBJ=SETPLLPARAMETERS(OBJ,N,P,Q) sets the P and Q values for PLL
%  number N.
%
%  Copyright (c) 2005 Opal Kelly Incorporated
%  $Rev: 236 $ $Date: 2005-12-10 14:32:28 -0800 (Sat, 10 Dec 2005) $

calllib('okFrontPanel', 'okPLL22393_SetPLLParameters', obj.ptr, n, p, q, en);
