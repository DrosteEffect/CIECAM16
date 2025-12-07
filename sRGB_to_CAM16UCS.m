function [Jab,csname,zyxlbl] = sRGB_to_CAM16UCS(rgb,isd,varargin)
% Convert an array of sRGB values to perceptually uniform CAM16 values.
%
%%% Syntax %%%
%
%   Jab = sRGB_to_CAM16UCS(rgb)
%   Jab = sRGB_to_CAM16UCS(rgb,isd)
%   Jab = sRGB_to_CAM16UCS(rgb,isd,space)
%   Jab = sRGB_to_CAM16UCS(rgb,isd,K_L,c1,c2)
%
% If the output is being used for calculating the euclidean color distance
% (i.e. deltaE) then specify isd=true, so that J' values are divided by K_L.
%
%% Examples %%
%
%   >> rgb = [64,128,255]/255;
%   >> Jab = sRGB_to_CAM16UCS(rgb)
%   Jab =
%        56.917    -7.9440    -33.593
%
%   >> rgb = uint8([64,128,255]);
%   >> Jab = sRGB_to_CAM16UCS(rgb)
%   Jab =
%        56.917    -7.9440    -33.593
%
%% Input Arguments (**==default) %%
%
%   rgb = Numeric array of sRGB values to convert. Floating point values
%         must be 0<=rgb<=1, integer must be 0<=rgb<=intmax(class(rgb)).
%         Size Nx3 or RxCx3, the last dimension encodes the R,G,B values.
%   isd = true    -> scale J' for euclidean distance calculations (divide by K_L)
%       = false** -> return reference J' values (no scaling).
%   space = StringScalar or CharRowVector, one of the following:
%           'LCD'/'SCD'/'UCS'**, which selects a predefined CAM16 space
%           LargeColorDifference / SmallColorDifference / UniformColorSpace.
%           'UCSHF' selects the UCS proposed by Hellwig & Fairchild.
%
%% Output Arguments %%
%
%   Jab = Array of CAM16 colorspace values J'a'b'. The same
%         class & size as <rgb>, the last dimension encodes the J',a',b' values.
%
%% Dependencies %%
%
% * MATLAB R2009a or later.
% * CIE_whitepoint.m, CIECAM16_parameters.m, CIEXYZ_to_CIECAM16.m,
%   sRGB_to_CIEXYZ.m, CAM16UCS_parameters.m, and CIECAM16_to_CAM16UCS.m
%   all from <https://github.com/DrosteEffect/CIECAM16>
%
% See also CAM16UCS_TO_SRGB CAM16UCS_PARAMETERS CIECAM16_PARAMETERS
% CIE_WHITEPOINT CAM16UCS_TO_CIECAM16 SRGB_TO_CIEXYZ MAXDISTCOLOR

%% Input Wrangling %%
%
isz = size(rgb);
%
%% RGB2Jab %%
%
wp  = CIE_whitepoint('D65');
two = CIECAM16_parameters(wp,20,64/pi/5,'average');
c16 = CIEXYZ_to_CIECAM16(sRGB_to_CIEXYZ(rgb),two);
one = CAM16UCS_parameters(varargin{:});
Jab = CIECAM16_to_CAM16UCS(c16,one,nargin>1&&isd);
%
Jab = reshape(Jab,isz);
%
csname = strcat('CAM16',one.suffix);
zyxlbl = strcat({'J_{','a_{','b_{'},one.suffix,'}');
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sRGB_to_CAM16UCS
% Copyright (c) 2017-2025 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license