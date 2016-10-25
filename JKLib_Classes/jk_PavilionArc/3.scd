SplineGen

like EnvGen, but plays a Spline

SplineGen(spline,dimension,loop)

	spline : 		an instance of a Spline subclass
	dimension:	the time dimension.  0 is x, 1 is y
	loop:		wraps the time-interpolated spline around and plays it in a loop

note the following are instance methods, not class methods as normal for pseudo-ugens


kr(timeScale=1.0,doneAction=0,divisions=512)


s.boot;

// BSpline
(
b = BSpline([ [ 0, 2.275 ], [ 1, 1 ], [ 2.5102880658436, 3.1 ], [ 4, 4 ] ], 2.0, false);

b.gui(nil,1000@300);

)

(
{
	Saw.ar(1000 * SplineGen(b).kr(doneAction:2))
}.play
)



// Linear
(

b = LinearSpline( Array.fill(60,{ arg i; [ i,1.0.rand ] }) );

b.gui(nil,1200@300);
)
(
{
	PinkNoise.ar * SplineGen(b).kr(doneAction:2)
}.play
)


Loop

Its not the spline that loops (that would be a loop in 2 dimensional space) but the SplineGen that is set to loop.

(
// the spline does NOT loop,
b = BSpline( Array.fill(16,{ arg i; [ i * 0.25,1.0.rand ] }), 3.0,false );

b.gui(nil,1200@300);


)
(
// the SplineGen loops
{
	Saw.ar(SplineGen(b,loop:true).kr.linexp(0.0,1.0,40,500).clip(40,500)).dup * 0.4
}.play
)


readKr
(

//
{
	Saw.ar(SplineGen(b,loop:true).readKr(MouseX.kr(0.0,5.0)).linexp(0.0,1.0,40,500).clip(40,500)).dup * 0.4
}.play
)


xyKr


not behaving yet. might move this to osc or a separate UGen

 returns an array of kr following each dimension
 returns as many dims as you have, not just xy
 time is the path along the spline
 the total tangent length along spline could be summed so that you could specify the speed of circuit revolution
 but only if its 2 dimensions (using point hypot)

 so just crank the speed up until you like it

(
b = BSpline( Array.fill(8,{ arg i; [ exprand(40,500),1.0.rand ] }), 3.0,false );

b.gui(nil,1200@300);

)

(
{
	# f , w = SplineGen(b,0,loop:true).xyKr(MouseY.kr(0.1,20),32);
	Pulse.ar(f.clip(40,500),w.clip(0.0,1.0),0.4).dup
}.play
)

b.interpolate(32).flop.plot2

