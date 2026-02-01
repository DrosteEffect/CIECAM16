function prm = CIECAM16_parameters(wp,Y_b,L_A,sur,ins)
% Parameter values defined in the CIECAM16 model "Step 0".
%
%%% Syntax %%%
%
%   prm = CIECAM16_parameters(wp,Y_b,L_A)
%   prm = CIECAM16_parameters(wp,Y_b,L_A,sur)
%   prm = CIECAM16_parameters(...,ins)
%
%% Input Arguments (**==default) %%
%
%   wp  = NumericVector, whitepoint XYZ values [Xw,Yw,Zw], 1931 XYZ colorspace (Ymax==1).
%   Y_b = NumericScalar, relative luminance factor of the background.
%   L_A = NumericScalar, adapting field luminance (cd/m^2).
%   sur = CharRowVector, one of 'dim'/'dark'/'average'**.
%       = NumericVector, size 1x3, [F,c,N_c], CIECAM16 surround parameters.
%   ins = true**, use Nico Schlömer's algorithmic improvements.
%         false, use the original CIE algorithm.
%
%% Output Arguments %%
%
%   prm = ScalarStructure of CIECAM16 parameter values.
%
%% Dependencies %%
%
% * MATLAB R2009b or later.
%
% See also CAM16UCS_PARAMETERS
% CIEXYZ_TO_CIECAM16 CIECAM16_TO_CIEXYZ SRGB_TO_CAM16UCS CAM16UCS_TO_SRGB

%% Input Wrangling %%
%
assert(isnumeric(L_A)&&isscalar(L_A)&&isreal(L_A),...
	'SC:CIECAM16_parameters:L_A:NotScalarNumeric',...
	'3rd input <L_A> must be a real scalar numeric.')
assert(isnumeric(Y_b)&&isscalar(Y_b)&&isreal(Y_b),...
	'SC:CIECAM16_parameters:Y_b:NotScalarNumeric',...
	'2nd input <Y_b> must be a real scalar numeric.')
assert(isnumeric(wp)&&numel(wp)==3&&isreal(wp),...
	'SC:CIECAM16_parameters:wp:NotThreeNumeric',...
	'1st input <wp> must be 3 real values in a numeric vector.')
assert(wp(2)>=0&wp(2)<=1,...
	'SC:CIECAM16_parameters:wp:OutOfRange',...
	'1st input <wp> must define the whitepoint scaled for Ymax==1')
%
prm.XYZ_w = 100*double(reshape(wp,1,[]));
%
Y_b = double(Y_b);
L_A = double(L_A);
%
if nargin<4
	sur = 'average';
	ins = true;
elseif nargin<5
	if isequal(sur,0)||isequal(sur,1)
		ins = logical(sur);
		sur = 'average';
	else
		ins = true;
	end
end
%
prm.isns = ins;
%
if isnumeric(sur)
	assert(isreal(sur)&&numel(sur)==3,...
		'SC:CIECAM16_parameters:sur:NotThreeNumeric',...
		'4th input <sur> can be a 1x3 numeric vector')
	sur = double(sur);
	prm.F   = sur(1);
	prm.c   = sur(2);
	prm.N_c = sur(3);
else
	switch upper(sur)
		case 'AVERAGE'
			prm.F = 1.0;   prm.c = 0.690;   prm.N_c = 1.00;
		case 'DIM'
			prm.F = 0.9;   prm.c = 0.590;   prm.N_c = 0.90;
		case 'DARK'
			prm.F = 0.8;   prm.c = 0.525;   prm.N_c = 0.80;
		otherwise
			error('SC:CIECAM16_parameters:sur:UnknownValue',...
				'4th input <sur> value "%s" is not supported.',sur)
	end
end
%
%% Matrices %%
%
prm.M16 = [...
	+0.401288,+0.650173,-0.051461;...
	-0.250268,+1.204414,+0.045854;...
	-0.002079,+0.048952,+0.953127];
%
prm.h_i = [20.14;90.00;164.25;237.53;380.14];
prm.e_i = [0.8;0.7;1.0;1.2;0.8];
prm.H_i = [0;100;200;300;400];
%
%% Derive Parameters %%
%
prm.RGB_w = prm.XYZ_w * prm.M16.';
prm.D = prm.F .* (1-(1/3.6) .* exp(-(L_A+42)/92));
prm.D = max(0,min(1,prm.D));
%
prm.RGB_D = prm.D*100 ./ prm.RGB_w + 1 - prm.D;
prm.RGB_wc = prm.RGB_D .* prm.RGB_w;
% Luminance adaption limits (Gill extension):
prm.q_L = 0.26;
prm.q_U = max(150,max(prm.RGB_wc));
% Michaelis-Menten equation for the luminance level adaption factor:
prm.k = 1 ./ (5*L_A+1);
prm.F_L = (prm.k.^4 .* (5*L_A))/5 + ((1-prm.k.^4).^2 .* (5*L_A).^(1/3))/10;
%
prm.n = Y_b ./ prm.XYZ_w(2);
prm.z = 1.48 + sqrt(prm.n);
prm.N_bb = 0.725 * prm.n.^(-1/5);
prm.N_cb = prm.N_bb;
%
tmp = ((prm.F_L .* prm.RGB_wc)/100).^0.42;
if prm.isns
	prm.RGBa_wc = 400*(tmp ./ (27.13 + tmp));
	prm.A_w = (prm.RGBa_wc * [2;1;1/20]) * prm.N_bb;
else % CIE
	prm.RGBa_wc = 400*(tmp ./ (27.13 + tmp)) + 0.1;
	prm.A_w = (prm.RGBa_wc * [2;1;1/20] - 0.305) * prm.N_bb;
end
%
prm.mfname = mfilename();
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CIECAM16_parameters
% Copyright (c) 2017-2026 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license