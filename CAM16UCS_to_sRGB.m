function [rgb,raw,XYZ] = CAM16UCS_to_sRGB(Jab,isd,varargin)
% Convert an array of perceptually uniform CAM16 colorspace values to sRGB values.
%
%%% Syntax %%%
%
%   rgb = CAM16UCS_to_sRGB(Jab)
%   rgb = CAM16UCS_to_sRGB(Jab,isd)
%   rgb = CAM16UCS_to_sRGB(Jab,isd,<opts>)
%
% If the input was being used for calculating the euclidean color distance
% (i.e. deltaE) use isd=true, so that J' values are multiplied by K_L.
%
%% Example %%
%
%   >> Jab = sRGB_to_CAM16UCS([64,128,255]/255)
%   Jab = [58.7620,-0.4543,-32.5929]
%   >> rgb = CAM16UCS_to_sRGB(Jab)*255
%   rgb =
%         64    128    255
%
%% Input Arguments (**==default) %%
%
%   Jab = Double/single array, CAM16 perceptually uniform colorspace values J'a'b'.
%         Size Nx3 or RxCx3, the last dimension encodes the J',a',b' values.
%   isd = true    -> scale J' for euclidean distance calculations (divide by K_L)
%       = false** -> return reference J' values (no scaling).
%   <opts> = all trailing inputs are passed to CAM16UCS_parameters.
%
%% Output Arguments %%
%
%   rgb = NumericArray of sRGB colorspace values, scaled so 0<=rgb<=1. Has the
%         same class & size as <Jab>, the last dimension encodes the R,G,B values.
%
%% Dependencies %%
%
% * MATLAB R2009b or later.
% * CAM16UCS_parameters.m, CAM16UCS_to_CIECAM16.m, get_whitepoint.m,
%   CIECAM16_parameters.m, CIECAM16_to_CIEXYZ.m, and CIEXYZ_to_sRGB.m 
%   all from <https://github.com/DrosteEffect/CIECAM16>
%
% See also SRGB_TO_CAM16UCS CAM16UCS_PARAMETERS CIECAM16_PARAMETERS
% GET_WHITEPOINT CAM16UCS_TO_CIECAM16 SRGB_TO_CIEXYZ MAXDISTCOLOR

%% Input Wrangling %%
%
isz = size(Jab);
%
%% Jab2RGB %%
%
one = CAM16UCS_parameters(varargin{:});
cam = CAM16UCS_to_CIECAM16(Jab,one,nargin>1&&isd);
two = CIECAM16_parameters(get_whitepoint(),20,64/pi/5,'average');
XYZ = reshape(CIECAM16_to_CIEXYZ(cam,two),isz);
[rgb,raw] = CIEXYZ_to_sRGB(XYZ);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CAM16UCS_to_sRGB
% Copyright (c) 2017-2026 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license