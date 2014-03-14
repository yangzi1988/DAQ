function [ ] = plot_scanvector( myscanvector, message)

    DAQ_constants_include;
    
    vectorlength = length(myscanvector);
%     printvector = dec2bin(myscanvector,16)
    toplot = dec2bin(myscanvector,16)-'0';
    toplot = 0.5*toplot + ones(vectorlength,1) * (15:-1:0);
    
    figure('numbertitle','off','name', ['Scan Vector: ' message],'color', lightwhite);
        stairs(toplot);
            ylabel('EXTBUSOUT PIN');
            xlabel('Time [clock cycles]');
%             set(gca,'YTick', 1:1:15);
%             set(gca,'YTickLabel', 0:1:14);

    
end
