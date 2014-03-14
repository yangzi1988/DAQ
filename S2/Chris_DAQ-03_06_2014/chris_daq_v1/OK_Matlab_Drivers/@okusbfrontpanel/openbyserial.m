function obj=openbyserial(obj, str)

%OPENBYSERIAL  Open an Opal Kelly FrontPanel-enabled device.
%  Opens an attached device by serial number.
%
%  OBJ=OPENBYSERIAL(OBJ, '') opens the first device found.
%
%  OBJ=OPENBYSERIAL(OBJ, STRING) opens a device identified by serial
%  number STRING.
%
%  Copyright (c) 2005 Opal Kelly Incorporated
%  $Rev: 210 $ $Date: 2005-10-13 19:54:17 -0700 (Thu, 13 Oct 2005) $

if ~exist('str','var');
	str = '';
end

ret = calllib('okFrontPanel', 'okFrontPanel_OpenBySerial', obj.ptr, str);
