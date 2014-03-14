

%function DAQ_sendscanvector1(xem,scanvectorfile)

function DAQ_sendscanvector2(xem,myInstructions1)




% ==========================================
error('disabled sendscanvector2')
% ==========================================




DAQ_constants_include;


packet1 = typecast(myInstructions1(:),'uint8');
 

bytes_sent1 = writetopipein(xem, EP_PIPEIN_TRIGGERTHRESHOLDS, packet1, length(packet1));
fprintf('bytes sent: %u\n',bytes_sent1);




end

