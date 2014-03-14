function epval = getboardmodel(obj)

%GETBOARDMODEL  Returns the board model of the current device.
%  GETBOARDMODEL(OBJ) returns the board model of the current
%  device, as a string:
%     'brdUnknown'
%     'brdXEM3001v1'
%     'brdXEM3001v2'
%     'brdXEM3001CL'
%     'brdXEM3005'
%     'brdXEM3010'
%     'brdXEM3020'
%     'brdXEM3050'
%
%  Copyright (c) 2005 Opal Kelly Incorporated
%  $Rev: 210 $ $Date: 2005-10-13 19:54:17 -0700 (Thu, 13 Oct 2005) $

brd = calllib('okFrontPanel', 'okFrontPanel_GetBoardModel', obj.ptr);

%{
if brd==0,
  brdModel = 'brdUnknown'
elsif brd==1,
  brdModel = 'brdXEM3001v1'
elsif brd==2,
  brdModel = 'brdXEM3001v2'
elsif brd==3,
  brdModel = 'brdXEM3010'
elsif brd==4,
  brdModel = 'brdXEM3005'
elsif brd==5,
  brdModel = 'brdXEM3001CL'
elsif brd==6,
  brdModel = 'brdXEM3020'
end

brdModel
%}

epval = brd;
