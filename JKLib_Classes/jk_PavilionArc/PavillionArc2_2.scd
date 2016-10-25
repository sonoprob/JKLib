Document.current.path;
/Users/a/dev/versioned/JKLib/JKLib_Classes/jk_PavilionArc/PavillionArc2_2.scd

// PavillionArc2.gui
// PavillionArc2.init;
Server.killAll;
s.boot;

// PavillionArc2.scope.window.bounds_(Rect(1680, 0, 1024, 768));
// PavillionArc2.scope.window.bounds_(Rect(1680, 0, 1024, 768));
// PavillionArc2.scope.window.bounds_(Rect(0, 0, 1024, 768));

// PavillionArc2.t.stop.start

s.boot;

// (
// ~lb = Rect(Window.screenBounds.width,0,1920,1080);
// ~rb = Rect(Window.screenBounds.width,0,1920,1080);
// p = PhaseScope.new(s, bounds:~lb);
// q = PhaseScope.new(s, bounds:~rb, inBus:2);
// )

// p.scopeSynth.set(\inBus, 2);
// q.scopeSynth.set(\inBus, 0);
//
// p.scopeView.yZoom_(0.1);
// q.scopeView.yZoom_(0.3);

PavillionArc2.free; PavillionArc2.init; PavillionArc2.play;

p = PhaseScope.new(s, bounds: Window.screenBounds);

PavillionArc2.t.set(\aconst,0, \afact,0,\bconst,0, \bfact,0);


PavillionArc2.t

/// sustainer
PavillionArc2.finalize(\sustain, 0.1, 1);
PavillionArc2.finalize(\compressor, 0.1, 1.9);

PavillionArc2.verber.set(\mix,0);
PavillionArc2.verber.set(\mix,0.01);

PavillionArc2.gui
PavillionArc2.w.front
PavillionArc2.w.visible_(false);

Ndef(\ij,{|fMul=1, rphase=0, lag=1| SinOsc.ar(fMul.lag3(lag)*[40,40.3],[0,rphase.lag3(lag)],0.3) }).play;
// Ndef(\ij,{|fMul=1, rphase=0, lag=1| SinOsc.ar(fMul.lag3(lag)*[37.7,38],[0,rphase.lag3(lag)],0.3) }).play;
Ndef(\ij,{|fMul=1, rphase=0, lag=1| SinOsc.ar(fMul.lag3(lag)* [ 29.966141537534, 30.190887599065 ],[0,rphase.lag3(lag)],0.6) }).play;
Ndef(\ij,{|fMul=1, rphase=0, lag=1| SinOsc.ar(fMul.lag3(lag)* [ 59.932283075067, 60.38177519813 ],[0,rphase.lag3(lag)],0.06) }).play;


([40,40.3].cpsmidi + 7 ).midicps

Ndef(\ij,{|fMul=1, rphase=0, lag=1| SinOsc.ar(fMul.lag3(lag)*[40,40.3],[0,rphase.lag3(lag)],0.3) }).play;
Ndef(\ij).clear;
PavillionArc2.group.set(\amp, 0.2)
PavillionArc2.fxGroup.set(\amp, 0.01)



PavillionArc2.t.stop

PavillionArc2.t.stop
.play;

/// interface
PavillionArc2.leftStrip;  PavillionArc2.ascope(style:2);

PavillionArc2.ascope(style:2);

PavillionArc2.t.set(\accwait, 20);



PavillionArc2.t.set(\acc, 2);
PavillionArc2.gui
PavillionArc2.w.front;
PavillionArc2.w.background_(Color.grey(0.5,0))


PavillionArc2.verber.set(\mix,0);
PavillionArc2.verber.set(\mix,0.001);
PavillionArc2.verber.set(\mix,0.05);
PavillionArc2.verber.set(\mix,0.4);
PavillionArc2.verber.set(\dly, 0.01, \dlysp,0.3, \lag, 7);



PavillionArc2.w.bounds_(Rect(300, 0, Window.screenBounds.width-400, Window.screenBounds.height))
// PavillionArc2.gui(Rect(300, 0, Window.screenBounds.width-400, Window.screenBounds.height));
PavillionArc2.w.close;

scope.window.bounds_(Rect(300, 0, Window.screenBounds.width-300, Window.screenBounds.height))

PavillionArc2.scope.window.bounds_(Rect(0, 300, 300, 300))


PavillionArc2.scope.window.bounds_(Rect(0, 0, 1280, 800))

// scope on 2nd scope
PavillionArc2.scope.window.bounds_(Rect(1680, 0, 1280, 800));



PavillionArc2.gui

PavillionArc2.w.close;

PavillionArc2.fxGroup.set(\dly, 0.001.exprand(0.7).postln, \lag, 7)
PavillionArc2.fxGroup.set(\dly, 0)

PavillionArc2.fxGroup.set(\mix, 0);


PavillionArc2.t.set(\accmul, 0.1, \accamt, 123, \accwait, 0, \accexp, 0.9);

PavillionArc2.t.set(\aconst, 0, \afact, 0.05, \bconst, 0, \bfact, 0.02, \wrap, true)
PavillionArc2.t.set(\accmul, 1, \accamt, 8, \accwait, 1, \accexp, 1);

PavillionArc2.t.set(\accmul, 1, \accamt, 8, \accwait, 1, \accexp, 0.98);

PavillionArc2.t.set(\accexpd, 0.01, \accexp, 0.94, \accwait, 1);

PavillionArc2.t.set(\accamt, 12, \accamtd, 8)

PavillionArc2.t.set(\accmul, 0.1, \accmuld, 0.3);

PavillionArc2.t.set(\accamt, 3, \accwait, 0);

PavillionArc2.t.set(\accamt, 3, \accwait, 0);


PavillionArc2.t.set(\accamt, 230, \accexp, 0.97)

PavillionArc2.t.set(\accamt, 530, \accexp, 0.95)

PavillionArc2.t.set(\accamt, 30, \accexp, 1.02, \accmul, 0.01)

PavillionArc2.t.set(\accamt, 80, \accexp, 1.03, \accmul, 0.01)

PavillionArc2.t.set(\accamt, 30, \accexp, 1.02, \accmul, 0.01)

PavillionArc2.t.set(\accamt, 200, \accexp, 1.03, \accmul, 0.01, \accwait, 0)







b=
PavillionArc2.w.bounds_(Rect(0, 600, 300, 1050-600))


PavillionArc2.loadSliderSettings([ 0, 0.09, 0.001, 0.2, 0, 0.97, 0.2, 3, 9, 1417, 19000, 5, 1, 0.07, 0.53, 1 ]);

//TODO: 2 lo hi, extra deviation param ?
PavillionArc2.loadSliderSettings2([ 0, 0.09, 0.001, 0.2, 0, 0.97, 0.2, 3, 9, 1417, 19000, 5, 1, 0.07, 0.53, 1 ], deviation);










/// finalize
// compressor (default)
// PavillionArc2.finalize(\compress, 0.7, 1);

PavillionArc2.w.bounds_(Rect(1050, 0, 630, 1050));


PavillionArc2.w.bounds_(Rect(850, 0, 630, 1050));


/////// make presets
a = List.new; b = List.new;
// -- wiggle sliders
PavillionArc2.saveSliderSettings(a);
a
// -- wiggle sliders
PavillionArc2.saveSliderSettings(b);
b
PavillionArc2.loadSliderSettings(a);
PavillionArc2.loadSliderSettings(b);





























PavillionArc2.ascope(style: 1);

PavillionArc2.verber.set(\dly, 0.02, \dlysp,0.3, \lag, 7);
PavillionArc2.verber.set(\dly, 0.06, \dlysp,0.03, \lag, 0.1);
PavillionArc2.verber.set(\dly, 0.01, \dlysp,0.3, \lag, 7);

PavillionArc2.verber.set(\dly, 0, \dlysp,0.3, \lag, 7);
PavillionArc2.verber.set(\dly, 0.0001, \dlysp,0.3, \lag, 7);
PavillionArc2.verber.set(\dly, 0.001, \dlysp,0.3, \lag, 7);

PavillionArc2.verber.set(\dly, 0.001.rand.postln, \dlysp,0.3, \lag, 1);

PavillionArc2.verber.set(\dly, 0.44)
PavillionArc2.verber.set(\dly, 0.05)
PavillionArc2.verber.set(\dly, 0.7)


PavillionArc2.verber.set(\dly, 0.004, \dlysp,0.3, \lag, 7);
PavillionArc2.verber.set(\dly, 0.54, \dlysp,0.3, \lag, 7);


PavillionArc2.verber.set(\dly, 0.53, \dlysp,0.1, \lag, 7);
PavillionArc2.verber.set(\dly, 0.52, \dlysp,0.5, \lag, 7);




PavillionArc2.t.set(\accamt , 16); // # of triggers per cycle
PavillionArc2.t.set(\accwait , 0.125);


PavillionArc2.t.set(\accamt , 128); // # of triggers per cycle
PavillionArc2.t.set(\accamt , 256); // # of triggers per cycle
PavillionArc2.t.set(\accamt , 512); // # of triggers per cycle



/*
// relative probability of
PavillionArc2.t.set(\doubleAcceleration, true);

// PavillionArc2.t.set(\doubleAcceleration, false);
PavillionArc2.t.set(\accelaration, 10, \deccelaration, 2, \regular, 0);
PavillionArc2.t.set(\accelaration, 0, \deccelaration, 2, \regular, 1);
PavillionArc2.t.set(\accelaration, 1, \deccelaration, 2, \regular, 0);
PavillionArc2.t.set(\accamt , 32); // # of triggers per cycle

*/

PavillionArc2.t.reset;

PavillionArc2.loadSliderSettings([ 1, 0.2, 0.001, 0, 0, 1.034, 0.1, 0, 9, 235, 19000, 30, 1, 0, 0.15, 1 ]);
PavillionArc2.loadSliderSettings([ 0, 0, 0.0639, 0.05, 0.0497, 0.805, 0.6, 9, 9, 500, 9525, 10, 0.4, 0, 0.5, 4.28 ])
PavillionArc2.loadSliderSettings([ 0, 0, 0.0272, 0.03, 0.0044, 0.946, 0.1, 3, 9, 3764, 6875, 38, 1, 0.01, 0.95, 0.94 ])
PavillionArc2.loadSliderSettings([ 0, 0, 0.0919, 0, 0, 0.994, 0.3, 3, 0.1, 3764, 19000, 88, 0.32, 0.48, 0.84, 0.94 ])


PavillionArc2.free;

/////// make presets
a = List.new; b = List.new;
// -- wiggle sliders
PavillionArc2.saveSliderSettings(a);
a


// PavillionArc2.fscope.window.close;
// PavillionArc2.fscope.dump
// PavillionArc2.fscope.window
// view

// PavillionArc2.fscope.scope