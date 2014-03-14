

function DAQ_sendscanvector(xem,scanvectorfile)

DAQ_constants_include;

bitinversions = bin2dec('0000000000000000');

packet = typecast(bitxor(cast(scanvectorfile, RAWDATAFORMAT),bitinversions),'uint8');

%printpacket=dec2bin(typecast(packet,RAWDATAFORMAT),32)

%bytes_sent = writetoblockpipein(xem, EP_PIPEIN_VECTOR, length(packet), packet, length(packet))
bytes_sent = writetopipein(xem, EP_PIPEIN_VECTOR, packet, length(packet));

% debug report
if show_debug_report == -1 || show_debug_report == 2 
    fprintf('bytes sent: %u\n',bytes_sent);
end
%pause(1);
%activatetriggerin(xem, EP_TRIGGERIN_SCAN, TRIGGERIN_SCAN_TRIGGER)



end %function


