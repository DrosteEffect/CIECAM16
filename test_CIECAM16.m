function test_CIECAM16()
% Test CIECAM16_TO_CIEXYZ and CIEXYZ_TO_CIECAM16 against sample values.
%
%% Dependencies %%
%
% * MATLAB R2009b or later.
% * CIECAM16_parameters.m, CIECAM16_to_CIEXYZ.m,
%   CIEXYZ_to_CIECAM16.m, and test_fun.m
%   all from <https://github.com/DrosteEffect/CIECAM16>
%
% See also TEST_FUN CIECAM16_TO_CIEXYZ CIEXYZ_TO_CIECAM16
fprintf('Running @%s...\n',mfilename())
%
% <https://colour.readthedocs.io/en/latest/generated/colour.XYZ_to_CIECAM16.html>
XYZ = [19.01,20.00,21.78]/100;
L_A = 318.31; Y_b = 20.0;
wp  = [95.05, 100, 108.88]/100;
prm = CIECAM16_parameters(wp,Y_b,L_A,'average');
J=41.7312079; C=0.1033557; h=217.0679597; s=2.3450150; Q=195.3717089; M=0.1074367; H=275.5949861;
%
test_fun(mkStruct(J,Q,C,M,s,H,h), @CIEXYZ_to_CIECAM16, XYZ, prm)
%
test_fun(XYZ, @CIECAM16_to_CIEXYZ, mkStruct(J,C,h), prm)
test_fun(XYZ, @CIECAM16_to_CIEXYZ, mkStruct(Q,C,h), prm)
test_fun(XYZ, @CIECAM16_to_CIEXYZ, mkStruct(J,M,h), prm)
test_fun(XYZ, @CIECAM16_to_CIEXYZ, mkStruct(Q,M,h), prm)
test_fun(XYZ, @CIECAM16_to_CIEXYZ, mkStruct(J,s,h), prm)
test_fun(XYZ, @CIECAM16_to_CIEXYZ, mkStruct(Q,s,h), prm)
test_fun(XYZ, @CIECAM16_to_CIEXYZ, mkStruct(J,C,H), prm)
test_fun(XYZ, @CIECAM16_to_CIEXYZ, mkStruct(Q,C,H), prm)
test_fun(XYZ, @CIECAM16_to_CIEXYZ, mkStruct(J,M,H), prm)
test_fun(XYZ, @CIECAM16_to_CIEXYZ, mkStruct(Q,M,H), prm)
test_fun(XYZ, @CIECAM16_to_CIEXYZ, mkStruct(J,s,H), prm)
test_fun(XYZ, @CIECAM16_to_CIEXYZ, mkStruct(Q,s,H), prm)
%
% <https://colour.readthedocs.io/en/latest/generated/colour.CIECAM16_to_XYZ.html>
J=41.731207905126638; C=0.103355738709070; h=217.067959767393010;
%
test_fun(XYZ, @CIECAM16_to_CIEXYZ, mkStruct(J,C,h), prm)
%
%test_fun(mkStruct(J,C,h), @CIEXYZ_to_CIECAM16, XYZ, prm)
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test_CIECAM16
function S = mkStruct(varargin)
C = varargin([1,1],:);
for k = 1:nargin
	C{1,k} = inputname(k);
end
S = struct(C{:});
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%mkStruct
% Copyright (c) 2017-2026 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license