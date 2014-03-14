

function DAQ_configurePLL(xem,xempll,CLK1FREQ,CLK2FREQ)

DAQ_constants_include;

% =========================================
% =========================================
PLL0 = 0;
PLL1 = 1;
PLL2 = 2;

CLK1 = 0;
CLK2 = 1;
CLK3 = 2;
CLK4 = 3;
CLK5 = 4;

%clock source options:
CLKSOURCE_REF = 'ok_ClkSrc22393_Ref';
CLKSOURCE_PLL0_0 = 'ok_ClkSrc22393_PLL0_0';
CLKSOURCE_PLL0_180 = 'ok_ClkSrc22393_PLL0_180';
CLKSOURCE_PLL1_0 = 'ok_ClkSrc22393_PLL1_0';
CLKSOURCE_PLL1_180 = 'ok_ClkSrc22393_PLL1_180';
CLKSOURCE_PLL2_0 = 'ok_ClkSrc22393_PLL2_0';
CLKSOURCE_PLL2_180 = 'ok_ClkSrc22393_PLL2_180';
% =========================================
% =========================================


%display(xempll);

% =========================================
OSCIN = 48;  %MHz, do not change
PREDIVIDER0 = 48;                 %Q ... actual predivider Q, not the exact PLL register value
MULTIPLIER0 = 100;                %P ... actual multiplier P, not the exact PLL register value
PREDIVIDER1 = 48;                 
MULTIPLIER1 = 100;                
PREDIVIDER2 = 48;                 
MULTIPLIER2 = 1;                


%(the max output divider is 128, but for VCO>333MHz use max 32)

CLK1_OUTPUTDIVIDER = OSCIN/PREDIVIDER0*MULTIPLIER0/(CLK1FREQ*1e-6);
CLK2_OUTPUTDIVIDER = OSCIN/PREDIVIDER1*MULTIPLIER1/(CLK2FREQ*1e-6);
CLK3_OUTPUTDIVIDER = 80;

% =========================================

%setreference(xempll, OSCIN);   % already done by constructor
setpllparameters(xempll, PLL0, MULTIPLIER0, PREDIVIDER0, true);
setpllparameters(xempll, PLL1, MULTIPLIER1, PREDIVIDER1, true);
%setpllparameters(xempll, PLL2, MULTIPLIER2, PREDIVIDER2, true);

setoutputsource(xempll, CLK1, CLKSOURCE_PLL0_0);
setoutputdivider(xempll, CLK1, CLK1_OUTPUTDIVIDER);
setoutputenable(xempll, CLK1, true);

setoutputsource(xempll, CLK2, CLKSOURCE_PLL1_0);
setoutputdivider(xempll, CLK2, CLK2_OUTPUTDIVIDER);
setoutputenable(xempll, CLK2, true);

setoutputsource(xempll, CLK3, CLKSOURCE_PLL0_0);
setoutputdivider(xempll, CLK3, CLK3_OUTPUTDIVIDER);
setoutputenable(xempll, CLK3, true);

setpll22393configuration(xem,xempll);

display(xempll);





