function v = getdeviceminorversion(obj)

%GETDEVICEMINORVERSION  Returns the device minor version number.
%  V=GETDEVICEMINORVERSION(OBJ) returns the minor version of the device.
%
%  Copyright (c) 2005 Opal Kelly Incorporated
%  $Rev: 210 $ $Date: 2005-10-13 19:54:17 -0700 (Thu, 13 Oct 2005) $

v = calllib('okFrontPanel', 'okFrontPanel_GetDeviceMinorVersion', obj.ptr);
