
function returnvector = VECTOR_biasDAC_AD5541A(biasDACvalue,fastcDACvalue)

DAQ_constants_include;


biasDACdata = zeros(1,DAC_SCANCHAIN_LENGTH);

fastcDACdata = zeros(1,DAC_SCANCHAIN_LENGTH);

DACbits = 16;

biasDACbinary = dec2bin(biasDACvalue,DACbits)-'0';
biasDACdata(DAC_MSB:-1:DAC_LSB) = biasDACbinary;

fastcDACbinary = dec2bin(fastcDACvalue,DACbits)-'0';
fastcDACdata(DAC_MSB:-1:DAC_LSB) = fastcDACbinary;

% ===================================================
% ===================================================


%returnvector = EPBIT_DACSDI*biasDACdata
returnvector = EPBIT_DACSDI*biasDACdata + EPBIT_DACSDI_FASTC*fastcDACdata;

%returnvector = returnvector(length(returnvector):-1:1);

returnvector = returnvector(:)';
           
%--- WRAP AROUND TWICE IF I WANT TO SEE SCANOUT ---
%returnvector  = [returnvector returnvector ];
% --------------------------

returnvector  = upsample(returnvector,2,0) + upsample(returnvector,2,1);

vectorlength = length(returnvector);
myclk = 0.5+0.5*square(1/1*3.1416*(2:(vectorlength+1)));
returnvector = returnvector + EPBIT_DACCLK*myclk;

returnvector = returnvector(vectorlength:-1:1);

returnvector = [    EPBIT_DACNCS+EPBIT_DAC_NLOAD          ...
                    EPBIT_DACNCS+EPBIT_DAC_NLOAD          ...
                    EPBIT_DAC_NLOAD                     ...
                    returnvector+EPBIT_DAC_NLOAD          ...
                    EPBIT_DACNCS+EPBIT_DAC_NLOAD          ...
                    EPBIT_DACNCS+EPBIT_DAQTRIGGER          ...
                    EPBIT_DACNCS+EPBIT_DAC_NLOAD          ...
                    ];

returnvector = returnvector + (EP_ACTIVELOWBITS-EPBIT_DACNCS-EPBIT_DAC_NLOAD);

lastelement = returnvector(length(returnvector));

% pad end of vector
returnvector = [returnvector lastelement*ones(1,32)];





end %function


