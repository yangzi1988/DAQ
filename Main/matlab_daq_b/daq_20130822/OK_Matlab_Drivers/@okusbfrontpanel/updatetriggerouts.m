function updatetriggerouts(obj)

%UPDATETRIGGEROUTS  Update all TriggerOut endpoints on the device.
%
%  Copyright (c) 2005 Opal Kelly Incorporated
%  $Rev: 210 $ $Date: 2005-10-13 19:54:17 -0700 (Thu, 13 Oct 2005) $

calllib('okFrontPanel', 'okFrontPanel_UpdateTriggerOuts', obj.ptr);
