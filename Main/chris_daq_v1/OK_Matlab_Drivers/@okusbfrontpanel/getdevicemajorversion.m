function v = getdevicemajorversion(obj)

%GETDEVICEMAJORVERSION  Returns the device major version number.
%  V=GETDEVICEMAJORVERSION(OBJ) returns the major version of the device.
%
%  Copyright (c) 2005 Opal Kelly Incorporated
%  $Rev: 210 $ $Date: 2005-10-13 19:54:17 -0700 (Thu, 13 Oct 2005) $

v = calllib('okFrontPanel', 'okFrontPanel_GetDeviceMajorVersion', obj.ptr);
