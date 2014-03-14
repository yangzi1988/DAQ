function id = getdeviceid(obj)

%GETDEVICEID  Returns the device ID string.
%  ID=GETDEVICEID(OBJ) returns the device ID string of the device.
%  This string is configurable by the user using SETDEVICEID.
%
%  Copyright (c) 2005 Opal Kelly Incorporated
%  $Rev: 210 $ $Date: 2005-10-13 19:54:17 -0700 (Thu, 13 Oct 2005) $

id = calllib('okFrontPanel', 'okFrontPanel_GetDeviceID', obj.ptr, '                                 ');
