
function returnvector = VECTOR_DPOT_AD5262(DPOTvalue,DPOTaddress)

DAQ_constants_include;


DPOTdata = zeros(1,DPOT_SCANCHAIN_LENGTH);
DPOTdata(DPOT_A) = DPOTaddress;

DPOTbits = 8;

DPOTbinary = dec2bin(DPOTvalue,DPOTbits)-'0';
DPOTdata(DPOT_MSB:-1:DPOT_LSB) = DPOTbinary;

% ===================================================
% ===================================================


returnvector = EPBIT_DPOT_SDI*DPOTdata;

%returnvector = returnvector(length(returnvector):-1:1);

returnvector = returnvector(:)';
           
%--- WRAP AROUND TWICE IF I WANT TO SEE SCANOUT ---
%returnvector  = [returnvector returnvector ];
% --------------------------

returnvector  = upsample(returnvector,2,0) + upsample(returnvector,2,1);

vectorlength = length(returnvector);
myclk = 0.5+0.5*square(1/1*3.1416*(2:(vectorlength+1)));
returnvector = returnvector + EPBIT_DPOT_CLK*myclk;

returnvector = returnvector(vectorlength:-1:1);

returnvector = [    EPBIT_DPOT_NCS          ...
                    0                     ...
                    returnvector          ...
                    0                     ...
                    EPBIT_DPOT_NCS          ...
                    ];

                
returnvector = returnvector + (EP_ACTIVELOWBITS-EPBIT_DPOT_NCS);                
                
%returnvector = returnvector + EPBIT_NLDAC;


%returnvector  = [returnvector returnvector];


%vectorlength = length(returnvector);




end %function


