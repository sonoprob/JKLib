~win.close;

s.quit;
s.boot;
s.reboot;
Server.killAll;
s.queryAllNodes;



(

Ndef(\signal,{ SinOsc.ar([441, 441.2, 443, 443.1] * 0.025,0,0.2) });


Ndef(\scopesnd,{
	var signal = Ndef(\signal).ar;
	ScopeOut2.ar(signal, ~bufEnvir[\bufferA], 1000); // 4 channels for waveScope
	ScopeOut2.ar([signal[0], signal[1]], ~bufEnvir[\bufferB], 1000); // First two channels for phaseScope
	ScopeOut2.ar([signal[2], signal[3]], ~bufEnvir[\bufferC], 1000); // Other two channels for phaseScope2+3
	Splay.ar(signal)
}).play;


)


Ndef(\signal).set(\freqMul, 1);
Ndef(\signal).set(\freqMul, 0.1);
Ndef(\signal).xset(\freqMul, 0.6);

Ndef(\signal,{|freqMul=1| SinOsc.ar(freqMul*[441, 441.2, 443, 443.1],0,0.2) });
Ndef(\signal,{|freqMul=1| Saw.ar(freqMul*[441, 441.2, 443, 443.1],0.2) });
Ndef(\signal,{|freqMul=1| Pulse.ar(freqMul*[441, 441.2, 443, 443.1],0.01, 0.2) });
Ndef(\signal,{|freqMul=1| Pulse.ar(freqMul*[441, 441.2, 443, 443.1],0.5, 0.2) });

Ndef(\signal).fadeTime_(10);
Ndef(\signal).fadeTime_(1);

s.boot;

(
~bufEnvir = BufEnvir(s);
~bufEnvir.alloc(\bufferA, 4096, 4);
~bufEnvir.alloc(\bufferB, 4096, 2);
~bufEnvir.alloc(\bufferC, 4096, 2);
~win.background_(Color.black)
)

(
// Overlaying two Lissajous plots

s = Server.default;

s.waitForBoot({

    var sound, waveScope, phaseScope, phaseScope2, phaseScope3; // several scopes
    // allocate audio buffers
	// var ~bufEnvir[\bufferA] = Buffer.alloc(Server.default, 4096,4);
	// var ~bufEnvir[\bufferB] = Buffer.alloc(Server.default, 4096,2);
	// var ~bufEnvir[\bufferC] = Buffer.alloc(Server.default, 4096,2);

	// create the main Window
	~win = Window("Multi Oscilloscope", 960@320).front
	.alwaysOnTop_(true)
    .onClose_({ // on close stop sound and free buffers
        sound.free;
        ~bufEnvir[\bufferA].free;
        ~bufEnvir[\bufferB].free;
		~bufEnvir[\bufferC].free;
    });

	// Create a second Window for bottom layer
	~win2 = Window("Single Oscilloscope", 320@320).front.alwaysOnTop_(true);

    ~win.addFlowLayout; // add a flowLayout to the main window

    // create the ScopeViews and set their buffers
    waveScope = ScopeView(~win,314@310).bufnum_(~bufEnvir[\bufferA].bufnum);
    phaseScope = ScopeView(~win,314@310).bufnum_(~bufEnvir[\bufferB].bufnum);
	phaseScope2 = ScopeView(~win,314@310).bufnum_(~bufEnvir[\bufferC].bufnum);
	phaseScope3 = ScopeView(~win2,314@310).bufnum_(~bufEnvir[\bufferC].bufnum); // A duplicate of phaseScope2


    // Start the scopes
    waveScope.server_(s);
    phaseScope.server_(s);
	phaseScope2.server_(s);
	phaseScope3.server_(s);
    waveScope.start;
    phaseScope.start;
	phaseScope2.start;
	phaseScope3.start;


    // a 4 channel test signal
    Ndef(\scopesnd,{
		var signal = SinOsc.ar([441, 441.2, 443, 443.1],0,0.2);
        ScopeOut2.ar(signal, ~bufEnvir[\bufferA], 1000); // 4 channels for waveScope
		ScopeOut2.ar([signal[0], signal[1]], ~bufEnvir[\bufferB], 1000); // First two channels for phaseScope
	    ScopeOut2.ar([signal[2], signal[3]], ~bufEnvir[\bufferC], 1000); // Other two channels for phaseScope2+3
		Splay.ar(signal)
	}).play;




    // customize waveScope
    waveScope.style_(0)   // Show the four channels in waveform view
      .waveColors_([Color.red,
Color.yellow]).background_(Color.gray(0.9,0.1))
      .xZoom_(1.7).yZoom_(2.2);   // scaling factors

    // customize phaseScope
    phaseScope.style_(2)   // lissajous first two channels, make background transparent
        .waveColors_([Color.magenta,
Color.green]).background_(Color.cyan(0.5, 0.1))
        .xZoom_(1.2).yZoom_(2.5);

	// customize phaseScope2
    phaseScope2.style_(2)   // lissajous second pair of channels, background transparent
	.waveColors_([Color.green, Color.magenta]).background_(Color.gray(0.9,0.1))
        .xZoom_(1.2).yZoom_(2.5);

	// customize phaseScope3
	phaseScope3.style_(2)   // lissajous second pair, opaque (place below the middle panel of the other window)
	.waveColors_([Color.green, Color.magenta]).background_(Color.cyan(0.8))
        .xZoom_(1.2).yZoom_(2.5);


	// Change window background colour.  Transparency doesn't work if the window background is left as nil. (Why?)
	~win.view.background.postln;
	~win.view.background_(Color.green);
	// Oddly, it is not the window's background colour that shows through the transparent child views,
	// but whatever is underneath the parent window.  Different from how sliders work.

})
)

// Now, you can drag the main window on top of the other so that the other window is under the middle panel of the first.
// The result is two overlaid Lissajous plots.