1. give the KtlLoop a function that looks up and evaluates a list of functions,

~funcsx = List[];
KtlLoop(\x, { |ev| ~funcsx.do(_.value(ev) ) });

KtlLoop(\x).func.value;
~funcsx.add({ |ev| "0: e.g. synth 1".post; ev.postln });
KtlLoop(\x).func.value((ev: \test));

// add some events to the list
KtlLoop(\x).startRec;
KtlLoop(\x).recordEvent((\dist: 1, \azim: 0.5));
KtlLoop(\x).stopRec;

KtlLoop(\x).play;
~funcsx.add({ |ev| "1: e.g. visuals 1".post; ev.postln });

// take first function out again
~funcsx.removeAt(0);

// etc


2. Use MFunc (in quark adclib) as a very flexible list of functions
than can be added/removed, enabled/disabled, switched in sets,
etc etc:

// make a empty MFunc, and put it into a KtlLoop
~xf = MFunc();
KtlLoop(\y, ~xf);

~xf = KtlLoop(\y).func;
~xf.add(\synth1, { |ev| "mfunc: synth1".post; ev.postln });
~xf.value((ev: \test));

// add an event to the list
KtlLoop(\y).startRec;
KtlLoop(\y).recordEvent((\dist: 1, \azim: 0.5));
KtlLoop(\y).stopRec;

KtlLoop(\y).play;

// change synth func
~xf.add(\synth1, { |ev| "mfunc: SYNTH1! - ".post; ev.postln });
KtlLoop(\y).play;

// add a second one:
~xf.add(\viz1, { |ev| "mfunc: viz1 - ".post; ev.postln });
KtlLoop(\y).play;

// turn off synth1 control:
~xf.disable(\synth1);
KtlLoop(\y).play;

// etc etc



KtlLoop was mainly written for recoding loops on the fly and playing with them,
and I did not get around to writing load, save methods yet.

you can do that by hand:

// k is a KtlLoop, and it has recorded lists
// put the lists in a text document:
Document("KtlLoop_lists.scd", k.lists.cs);
// and save it as a file e.g. on the desktop

// for testing, clear the lists:
k.lists.clear;
l = "~/Desktop/KtlLoop_lists.scd".loadPaths.first;
k.lists.addAll(l);

// now the lists should be back
k.lists;

