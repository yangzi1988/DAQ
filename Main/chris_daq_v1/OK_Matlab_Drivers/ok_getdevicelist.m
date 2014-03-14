function [mlist,snlist]=ok_getdevicelist()

%OK_GETDEVICELIST  Returns a list of attached XEM devices.
%  [M,SN]=OK_GETDEVICELIST() looks for attached XEM devices.
%  It returns the device models in M, serial numbers in SN.
%  The serial number can then be used to open an attached XEM
%  for use.
%
%  Copyright (c) 2005 Opal Kelly Incorporated
%  $Rev: 424 $ $Date: 2006-12-18 20:27:54 -0800 (Mon, 18 Dec 2006) $

if ~libisloaded('okFrontPanel')
	loadlibrary('okFrontPanel', 'okFrontPanelDLL.h');
end

mlist = [];
snlist = [];

% Try to construct an okUsbFrontPanel and open it (the board model doesn't matter).
xptr = calllib('okFrontPanel', 'okFrontPanel_Construct');
num = calllib('okFrontPanel', 'okFrontPanel_GetDeviceCount', xptr);
for j=1:num
   m = calllib('okFrontPanel', 'okFrontPanel_GetDeviceListModel', xptr, j-1);
   %sn = calllib('okFrontPanel', 'okFrontPanel_GetDeviceListSerial', xptr, j-1, '           ', 10);
   
   p = libpointer('cstring');
   [nothing,sn] = calllib('okFrontPanel', 'okFrontPanel_GetDeviceListSerial', xptr, j-1, '          ');
   
   
   %setdatatype(sn,'cstring',10)
   %sn.Value
   
   if ~exist('snlist', 'var')
      mlist = m;
      snlist = sn;
   else
      mlist = [mlist;m];
      snlist = char(snlist, sn);
   end
end
calllib('okFrontPanel', 'okFrontPanel_Destruct', xptr);
