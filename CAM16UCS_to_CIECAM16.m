function out = CAM16UCS_to_CIECAM16(Jab,prm,isd)
% Convert an array of CAM16 colorspace values to a structure of CIECAM16 values.
%
%%% Syntax %%%
%
%   out = CAM16UCS_to_CIECAM16(Jab,prm)
%   out = CAM16UCS_to_CIECAM16(Jab,prm,isd)
%
% If the input was being used for calculating the euclidean color distance
% (i.e. deltaE) then set isd=true, so that J' values are multiplied by K_L.
%
%% Example %%
%
%   >> Jab = [56.9174814457648495,-7.94398845807383758,-33.5932377101949626];
%   >> prm = CAM16UCS_parameters();
%   >> out = CAM16UCS_to_CIECAM16(Jab,prm)
%   out =
%       J:  43.730
%       M:  52.496
%       h: 256.70
%
%% Input Arguments (**==default) %%
%
%   Jab = Double/single array, CAM16 perceptually uniform colorspace values J',a',b'.
%         Size Nx3 or RxCx3, the last dimension encodes the J'a'b' values.
%   prm = ScalarStructure of parameters from the function CAM16UCS_PARAMETERS.
%   isd = true    -> scaled J' for euclidean distance calculations (divided by K_L)
%       = false** -> reference J' values (no scaling).
%
%% Output Arguments %%
%
%   out = ScalarStructure of CIECAM16 J, M|C, and h values. Each field has the
%         class of <Jab>, and either size Nx1 or RxCx1. The fields encode:
%         J = Lightness
%         M = Colorfulness
%         C = Chroma
%         h = Hue Angle
%
%% Dependencies %%
%
% * MATLAB R2009b or later.
% * CAM16UCS_parameters.m <https://github.com/DrosteEffect/CIECAM16>
%
% See also CIECAM16_TO_CAM16UCS CAM16UCS_PARAMETERS
% CAM16UCS_TO_SRGB SRGB_TO_CAM16UCS CIECAM16_TO_CIEXYZ

%% Input Wrangling %%
%
isz = size(Jab);
assert(isfloat(Jab),...
	'SC:CAM16UCS_to_CIECAM16:Jab:NotFloat',...
	'1st input <Jab> must be a floating point array.')
assert(isreal(Jab),...
	'SC:CAM16UCS_to_CIECAM16:Jab:NotReal',...
	'1st input <Jab> must be a real array (not complex).')
assert(isz(end)==3 || isequal(isz,[3,1]),...
	'SC:CAM16UCS_to_CIECAM16:Jab:InvalidSize',...
	'1st input <Jab> last dimension must have size 3 (e.g. Nx3 or RxCx3).')
isz(end) = 1;
%
Jab = reshape(Jab,[],3);
%
Jp = Jab(:,1);
ap = Jab(:,2);
bp = Jab(:,3);
%
mfname = 'CAM16UCS_parameters';
assert(isstruct(prm)&&isscalar(prm),...
	'SC:CAM16UCS_to_CIECAM16:prm:NotScalarStruct',...
	'2nd input <prm> must be a scalar structure.')
assert(strcmp(prm.mfname,mfname),...
	'SC:CAM16UCS_to_CIECAM16:prm:UnknownStructOrigin',...
	'2nd input <prm> must be the structure returned by "%s.m".',mfname)
%
%% Jab2JMh %%
%
if nargin>2&&isd
	Jp = Jp * prm.K_L;
end
%
J  = -Jp ./ (prm.c1 * Jp - 100*prm.c1 -1);
%
h  = myAtan2d(bp,ap);
Mp = hypot(ap,bp);
%
if strcmpi('HF',prm.suffix(end-1:end))
	%
	C = (exp(prm.k * Mp / prm.n) - 1) / prm.k;
	%
	out = struct('J',J,'C',C,'h',h);
else
	%
	M  = (exp(prm.c2*Mp) - 1) / prm.c2;
	%
	out = struct('J',J,'M',M,'h',h);
end
%
out = structfun(@(v)reshape(v,isz), out, 'UniformOutput',false);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CAM16UCS_to_CIECAM16
function ang = myAtan2d(Y,X)
% ATAN2 with an output in degrees. Note: ATAN2D only introduced R2012b.
ang = mod(360*atan2(Y,X)/(2*pi),360);
ang(Y==0 & X==0) = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%myAtan2d
% Copyright (c) 2017-2026 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license