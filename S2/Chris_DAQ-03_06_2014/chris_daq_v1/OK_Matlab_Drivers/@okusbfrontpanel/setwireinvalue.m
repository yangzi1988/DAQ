function setwireinvalue(obj, epaddr, epvalue, epmask)

%SETWIREINVALUE  Write into WireIn values of the device.
%  SETWIREINVALUE(OBJ,epADDR,epVALUE,epMASK) writes
%  a value into a WireIn endpoint of a the device.
%  The elements of epVALUE need to be ints (16 bits : 0..65535)
%  stored as fints (floating point integers). epVALUE will have
%  the same dimension as epADDR.
%
%  The valid endpoint address ranges are:
%  * 0x00-0x1F : WireIn
%    0x20-0x3F : WireOut
%    0x40-0x5F : TriggerIn
%    0x60-0x7F : TriggerOut
%    0x80-0x9F : PipeIn
%    0xA0-0xBF : PipeOut
%
%  Copyright (c) 2005 Opal Kelly Incorporated
%  $Rev: 210 $ $Date: 2005-10-13 19:54:17 -0700 (Thu, 13 Oct 2005) $

for i=1:size(epaddr, 1)
	for j=1:size(epaddr, 2)
		calllib('okFrontPanel', 'okFrontPanel_SetWireInValue', obj.ptr, epaddr(i,j), epvalue(i,j), epmask(i,j));
	end
end
