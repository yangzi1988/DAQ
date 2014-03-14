

function DAQ_updateFSMholdseconds(handles,holdseconds)

%disp('start potvalues update');

DAQ_constants_include;

myHoldeSeconds= (holdseconds*1000/2.5);

myInstructions = uint32(myHoldeSeconds);

DAQ_sendFSMholdseconds (handles.xem, myInstructions);
end



