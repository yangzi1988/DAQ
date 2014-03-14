


% 'outputvoltages' is a 2xN array with the differential voltages of ch12/34
function returnvector = DAQ_generatevector1(outputvoltages)

DAQ_constants_include;

numsamples = size(outputvoltages,2);
CM = DACFULLSCALE / 2;

DACvoltages(1,:) = CM - 0.5*outputvoltages(1,:);
DACvoltages(2,:) = CM + 0.5*outputvoltages(1,:);

DACvoltages(3,:)= CM - 0.5*outputvoltages(2,:);
DACvoltages(4,:)= CM + 0.5*outputvoltages(2,:);

DACvalues = mod( floor( DACvoltages ./ DACFULLSCALE * 2^DACBITS ) - 1, 2^DACBITS );


DACvector = [   DACvalues(1,:); ...
                DACvalues(2,:)+EPBIT_DACA0; ...
                DACvalues(3,:)+EPBIT_DACA1; ...
                DACvalues(4,:)+EPBIT_DACA1+EPBIT_DACA0+EPBIT_DACUPDATE ...
                ];

%{            
DACvector = [   DACvalues(1,:)+EPBIT_DACA2; ...
                DACvalues(2,:)+EPBIT_DACA2+EPBIT_DACA0; ...
                DACvalues(3,:)+EPBIT_DACA2+EPBIT_DACA1; ...
                DACvalues(4,:)+EPBIT_DACA2+EPBIT_DACA1+EPBIT_DACA0+EPBIT_DACUPDATE ...
                ];
%}            
            
            
%extend the last value in all vectors by one transfer length so they don't get stranded
DACvector = [ DACvector repmat(DACvector(:,numsamples),[1 DAC_xfer_len/4]) ];

returnvector = DACvector(1:numel(DACvector));
%vectorlength = length(returnvector)


end %function


