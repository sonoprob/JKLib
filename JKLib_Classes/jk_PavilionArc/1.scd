BSpline


BSpline(points,order,isClosed)

	points:	an array of Points,
			may also be an array of arrays for splines in 3 or more dimensions
	order:	curvature of interpolation
	isClosed:	true/false if the end point loops back to the first point

(
b = BSpline([0@0,1@1,3.2@2,4@4]);
b.gui(nil,1000@200);
)

// edited splines can be saved:
b.asCompileString


interpolate

returns points spaced evenly along the spline in 2D space

b.interpolate(512).postln.flop.plot2

due to the wslib implementation this returns 512 interpolations PER segment


// use ScatterView in MathLib to show interpolated points
(
w = Window(bounds: Rect(40, 40, 800, 800)).front;
a = ScatterView(w, Rect(10, 10, 760, 760),b.interpolate(20),ControlSpec(0.0,5.0),ControlSpec(0.0,5.0));
a.drawAxis_(true).drawMethod_(\fillOval)
	.symbolColor_(Color.blue(0.5, 0.5)).symbolSize_(5)

)

bilinearInterpolate

 return y values for evenly spaced intervals along x (eg. steady time increments)
 whereas interpolate returns a series of points evenly spaced along the spline path
 this linear interpolates between those known points to find y.

 This is useful to interpret a spline as a function of time, like an envelope, and is used by SplineGen to create a lookup table.

	divisions: number of interpolations
	domain:	the dimension along which evenly spaced divisions occur
		0: returns y values for evenly spaced x
		1: return x values for evenly spaced y

		Any higher dimensions are ignored and a domain of higher than 0/1 won't work

	fillEnds: true/false to fill the beginning and end with the first and last point respectively
		if false then those values are nil


(
b = BSpline([ [ 0.42695473251029, 2.275 ], [ 1, 1 ], [ 2.5102880658436, 3.1 ], [ 4, 4 ] ]);
b.gui;
// to use X as time we need y values spaced in even X units
d = b.bilinearInterpolate(512);

d.plot2;
x = 5.0/512;
// collect into points for plotting
e = d.collect({ |dd,i| [x * i,dd] });

w = Window(bounds: Rect(40, 40, 800, 800)).front;
a = ScatterView(w, Rect(10, 10, 760, 760),
	e,
	ControlSpec(0.0,5.0),
	ControlSpec(0.0,5.0));
a.drawAxis_(true).drawMethod_(\fillOval)
	.symbolColor_(Color.blue(0.5, 0.5)).symbolSize_(5);

)

The bend in the road

If X is time, then time must of course march ever onwards.

If a spline point is to the left of a previous spline point then the spline path has travelled backwards in time

(
b = BSpline([ [ 0, 2.5 ], [ 2.9044117647059, 1.225 ], [ 2.5275735294118, 2.8946875 ], [ 5.5836397058824, 4.58734375 ] ]);

b.gui;

b.bilinearInterpolate(512).plot2
)

So you can see that the interpolation which progresses always forward in time is bounded in the X dimension until the spline resumes travelling forward in the X direction.

... or even with certain curvature settings:

(
b = BSpline([ [ 0, 2.5 ], [ 2.9044117647059, 1.225 ], [ 3.1479779411765, 2.55125 ], [ 5.5836397058824, 4.58734375 ] ], 3.0);

b.gui;

b.bilinearInterpolate(512).plot2
)

then mapping along the X dimension can only yield one value for Y.  That is always the first encountered value. This is to stop you from going back in time to kill your Grandfather.

In 3D this would be visibility: if the road curves to the left of the mountain, you cannot see it until it comes back out.  In 3D rendering the area behind the curve would not be visible.


TODO:

Negative time

it is mathematically legal for a spline to have points with negative x.  maybe should not assume to start interpolating at 0

also currently you cannot edit points "off screen" - those with negative x

(
b = BSpline([ [ -0.42695473251029, 2.275 ], [ 1, 1 ], [ 2.5102880658436, 3.1 ], [ 4, 4 ] ]);
b.bilinearInterpolate(100).plot2
)


is looping working correctly ?
a loop in 2D space is not what you are looking for in order to loop a spline in time.
but it still should give the correct (but unexpected) result
(

b = BSpline([ [ 0, 2.5 ], [ 2.9044117647059, 1.225 ], [ 2.5275735294118, 2.8946875 ], [ 5.5836397058824, 4.58734375 ] ],3.0,true);

b.gui;

b.bilinearInterpolate(512).plot2
)




bicubic bilinear interpolation would be better

many interesting interpolations exist
see:
http://en.wikipedia.org/wiki/Multivariate_interpolation











// animate
(
b = BSpline([ Point(0,0), Point(0.58963874282376, 0.4134375), Point(2.2682499386103, 0.826875), Point(4.8180390967671, 0.013125) ], 2.3870967741935,false);
b.gui(nil,1000@200);
n = NumberEditor.new;
n.gui;
b.animate(n,'value_');
)





// todo: click handler on gui to change read position
// method to allocate and fill a buffer
// so that it can be edited and changes updated to buffer 