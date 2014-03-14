function sn = getserialnumber(obj)

%GETSERIALNUMBER  Returns the device serial number string.
%  SN=GETSERIALNUMBER(OBJ) returns the serial number of the device.
%  This string is set at the factory and stored in EEPROM.
%
%  Copyright (c) 2005 Opal Kelly Incorporated
%  $Rev: 210 $ $Date: 2005-10-13 19:54:17 -0700 (Thu, 13 Oct 2005) $

sn = calllib('okFrontPanel', 'okFrontPanel_GetSerialNumber', obj.ptr, '           ');
