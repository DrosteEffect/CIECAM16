CIECAM16 Color Appearance Model and CAM16 Uniform ColorSpace for MATLAB
=======================================================================

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=DrosteEffect/CIECAM16)

This code is based on the following sources:

1. the article "Algorithmic improvements for the CIECAM02 and CAM16 color
   appearance models" by Nico Schlömer, revised on the 14th of October 2021.
2. the article "Comprehensive color solutions: CAM16, CAT16, and CAM16-UCS"
   by Changjun Li, Zhiqiang Li, Zhifeng Wang, Yang Xu, Ming Ronnier Luo,
   Guihua Cui, Manuel Melgosa, Michael H. Brill, Michael Pointer in "Color
   Research and Application" Volume 42 Issue 6, published on the 10th of June 2017.

This code does _**not**_ require the Image Processing Toolbox!

This code is based on my CIECAM02 implementation: <https://github.com/DrosteEffect/CIECAM02>

My goal was to provide functionality as simple as the commonly used CIELab
colorspace conversions, whilst providing a much more perceptually uniform
colorspace. Note that I replaced calculations with a matrix inverse, e.g.
`inv(A)*b`, with the recommended and numerically more precise `\` or `/`,
see: <https://www.mathworks.com/help/matlab/ref/inv.html>

Quickstart Guide: As Easy As CIELAB!
------------------------------------

Many users will want to convert between sRGB and the CAM16 uniform colorspace,
just as easily as they might use `rgb2lab` and `lab2rgb`. This conversion
is easy with these convenience functions (i.e. `rgb2jab` and `jab2rgb`):

    Jab = sRGB_to_CAM16UCS(rgb)
    rgb = CAM16UCS_to_sRGB(Jab)

These use default values that are appropriate for sRGB (D65 illuminant, etc),
and the CAM16-UCS colorspace (option to select SCD, LCD, UCS, or UCSHF (Hellwig & Fairchild) colorspaces).
Note that the sRGB inputs are MATLAB standard float values `0<=rgb<=1`.

Other Conversions
-----------------

While most users will likely want to convert between sRGB and CAM16
colorspaces, the main functions provide the following conversions:

    CIEXYZ_to_CIECAM16()
    CIECAM16_to_CIEXYZ()

    CIECAM16_to_CAM16UCS()
    CAM16UCS_to_CIECAM16()

And for convenience in MATLAB (note that `XYZ` is scaled so `Ymax==1`):

    sRGB_to_CIEXYZ()
    CIEXYZ_to_sRGB()

Test Scripts
------------

Of course there is no point in writing a conversion this complex without
testing it thoroughly: test functions check the conversion between CIEXYZ
and CIECAM16 and CAM16 J'a'b'. The test values are those referenced in the
Python library "colour-science".
The test functions are included in this repository.