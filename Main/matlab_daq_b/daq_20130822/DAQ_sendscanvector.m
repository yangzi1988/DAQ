

function DAQ_sendscanvector(xem,scanvectorfile)

% this line was from Zi's new version
%function DAQ_sendscanvector(xem,myInstructions)

DAQ_constants_include;



bitinversions = bin2dec('0000000000000000');
packet = typecast(bitxor(cast(scanvectorfile, RAWDATAFORMAT),bitinversions),'uint8');

% this line was from Zi's new version
%packet = typecast(myInstructions(:),'uint8');


bytes_sent = writetopipein(xem, EP_PIPEIN_VECTOR, packet, length(packet));
fprintf('vector bytes sent: %u\n',bytes_sent);

%printpacket=dec2bin(typecast(myInstructions(:),'uint64'),64)
%printpacket=dec2bin(typecast(packet,'uint32'),32)

end %function


