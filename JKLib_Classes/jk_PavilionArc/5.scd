Suzi Wong
11
187(11*17)

// (12 * 60)
720 - 187

533 + 187

whole night = 12 * 60 = 1800


[---|---]

////////////////////////////////

EnvelopeView
Quarks.install("splines")

Splines
BSplines

Quarks.gui

l = LinearSpline({ { 4.0.rand } ! 2 } ! 9);
l.gui


l = LinearSpline({ { 4.0.rand } ! 6 } ! 12);
v = VectorSplineGui(l).gui(nil,1000@1000);


// used like a long envelope
b = LinearSpline( Array.fill(60,{ arg i; [ i,1.0.rand ] }) );
b.gui(nil,1200@300);
{
    PinkNoise.ar * SplineGen(b).kr(doneAction:2)
}.play

// travel along the spine of the spline outputting an x and a y control
{
    # f , w = SplineGen(b,0,loop:true).xyKr(MouseY.kr(0.1,20),32);
    Pulse.ar(f.clip(40,500),w.clip(0.0,1.0),0.4).dup
}.play



