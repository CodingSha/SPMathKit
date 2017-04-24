#MathKit

###What's New?
* New optimization to the extreme of the new rendering controls, efficiency and fluency have been greatly improved！`SPMathKit_N.zip`
* Support new codeType ,MathML code had been supported!!! MathML code is WebKit supported code,is so easy to render math code!!! Now,you can easy to build your app with MathKit to render math code with two easy-ways.

##What MathKit can do?

+ It will render you your math, physics, chemistry or any science formula,Geometric graphics and pictures, as well as general text.

+ MathKit used by the rendering engine from the current fastest performance of the best JavaScript mathematical formula rendering engine

+ MathKit the mathematical formula derived from the code is very simple and very easy to store the `Latex code`

Based on this, we believe that it will become the most popular science formula and graphics rendering Library
##Why you need MathKit?

* Strong rendering performance
* Very simple code
* Fast integration
* Minimal dependency Library
* support new codeType MathML

[KaTeX and MathJax Comparison Demo](http://www.intmath.com/cg5/katex-mathjax-comparison.php)

Time to process page with Katex = `80~100 ms`

Time to process page with MathJax = `900~2000 ms`

This shows that Katex faster than MathJax `10 times to 20 times`

And MathKit is `based on the Katex` engine to achieve

##Usage

1. Download all the files in the MathKit subdirectory.
2. Add the source files to your Xcode project.
3. Link with required frameworks:
	* CoreText
	* UIKit
	* [SDWebImage](https://github.com/rs/SDWebImage)
	* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
	* [YYText](https://github.com/ibireme/YYText)
4. Import `MathSubjectView.h`.
5. Initialization of an instance object, and give the `testStr` attribute assignment, where the object will be copied to the mixture of arbitrary science formulas and pictures of the string.
Note: Here's the formula in the string need to use a tag similar to `@math#...@/math#` wrapped up, and the picture will need to use a tag similar to `@image#...@/image#` wrapped up, so as to be recognized
6. Add the instance object to your view.

If you still do not know how to use it, then download the code to see it, the package has my prepared sample demo.

##Result
![img](http://git.oschina.net/uploads/images/2016/1202/102519_afa75c94_1128220.png)
