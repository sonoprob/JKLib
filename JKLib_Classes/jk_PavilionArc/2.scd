(
b = BSpline( Array.fill(16,{ arg i; [ i * 0.25,1.0.rand ] }), 3.0,false );
b.gui(nil,1200@300);
)

(
{
	Saw.ar(SplineGen(b,loop:true).kr.linexp(0.0,1.0,40,500).clip(40,500)).dup * 0.4
}.play
)
