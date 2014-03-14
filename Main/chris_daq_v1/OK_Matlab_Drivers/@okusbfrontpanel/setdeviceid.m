function setdeviceid(obj, stringID)

%SETDEVICEID  Set the device ID.
%  SETDEVICEID(XID,DEVICEID) sets the device ID of the device.
%  OBJ is the device class instance.  DEVICEID is a string vector,
%  with maximally 32 characters.
%
%  Example:
%    xid = okxem3001v2();
%    xid = setdeviceid(xid, 'Lab 3B XEM3001');
%
%  Copyright (c) 2005 Opal Kelly Incorporated
%  $Rev: 210 $ $Date: 2005-10-13 19:54:17 -0700 (Thu, 13 Oct 2005) $

if length(stringID) > 32, stringID = stringID(1:32); end;

calllib('okFrontPanel', 'okFrontPanel_SetDeviceID', obj.ptr, stringID);
