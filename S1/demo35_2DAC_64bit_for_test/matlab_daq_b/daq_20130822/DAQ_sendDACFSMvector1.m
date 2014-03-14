

%function DAQ_sendscanvector1(xem,scanvectorfile)

function DAQ_sendDACFSMvector1(xem,myInstructions)
DAQ_constants_include;

packet = typecast(myInstructions(:),'uint8');
 
bytes_sent = writetopipein(xem, EP_PIPEIN_DACFSM, packet, length(packet));
fprintf('DAC FSM bytes sent: %u\n',bytes_sent);

%printpacket=dec2bin(typecast(myInstructions(:),'uint32'),32)
printpacket=dec2bin(typecast(packet,'uint32'),32)

end %function


