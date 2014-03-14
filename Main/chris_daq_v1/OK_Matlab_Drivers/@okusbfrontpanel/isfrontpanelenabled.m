function s=isfrontpanelenabled(obj)

%ISFRONTPANELENABLED  Check if FrontPanel is enabled on XEM device.
%  S=ISFRONTPANELENABLED(OBJ) checks whether FrontPanel is enabled
%  on the device.
%  S=1 if FrontPanel is enabled, S=0 if FrontPanel access is not available.
%
%  Copyright (c) 2005 Opal Kelly Incorporated
%  $Rev: 210 $ $Date: 2005-10-13 19:54:17 -0700 (Thu, 13 Oct 2005) $

s = calllib('okFrontPanel', 'okFrontPanel_IsFrontPanelEnabled', obj.ptr);
