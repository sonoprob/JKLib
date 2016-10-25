/*

PhaseScope2

s.boot;

Ndef(\test,{ SinOsc.ar(240,SinOsc.ar(0.01,0,[0,pi]), 0.1) }).play

s.scope;

s.queryAllNodes;

m = PhaseScope2(0, s);
m.free;
s.queryAllNodes;

m
m.free;



*/


PhaseScope2 {

	var window;  // the parent window
	var waveScope, phaseScope, freqScope, meterScopes; // the scopes
	var buffers, meterBus, meterRout, synth; // used to update the scopes
	var <bus, <server; // the bus and server passed as arguments

	*new { arg bus = 0, server = Server.default;
		^super.new.init(bus,server);
	}

	init{ arg inBus, serv;
		bus = inBus;   // copy argument to variable
		server = serv; // copy argument to variable
		server.waitForBoot({ // wait for server to boot
			fork{
				buffers = Array.fill(2,{Buffer.alloc(server,1024,2)}); // allocate Buffers
				server.sync; // wait for server to sync

				meterBus = Bus.control(server,2); // allocate Bus
				server.sync; // wait for server to sync

				// add SynthDef
				SynthDef(\PhaseScopeSynth,{
					arg inBus, bufferA, bufferB;
					var signal, amplitudes;
					signal = In.ar(inBus,2); // read input bus
					amplitudes = Amplitude.kr(signal);
					ScopeOut.ar(signal,bufferA); // scopeOut to bufferA
					ScopeOut.ar(signal,bufferB); // scopeOut to bufferB
					Out.kr(meterBus,amplitudes);
				}).add;
				server.sync; // wait for server to sync

				{   this.prMakeGui;  // call method to create gui
					this.prStartScoping; // call method to start scoping
				}.defer; // schedule on the AppClock
			};
		});
	}

	prMakeGui{ //herein we create and customize the GUI elements
		// parent window
		var ww, wh;
		ww = Window.screenBounds.width;
		wh = Window.screenBounds.height;

		window = Window.new("...", ww@wh).front;
		window.background_(Color.grey(0,0));
		window.addFlowLayout; // add flowlayout
		window.onClose_({ // on close
			freqScope.kill; // kill freqScope
			buffers.do{arg item; item.free}; // free Buffers
			meterRout.stop; // stop routine
			synth.free; // free Synth
		});

		waveScope = ScopeView(window,(ww/2)@(wh/2)).style_(1).bufnum_(buffers[0].bufnum)
		.background_(Color.black).waveColors_([Color.red,Color.green])
		.yZoom_(0.5);
		// freqScope
		freqScope = FreqScopeView(window,(ww/2)@(wh/2)).active_(true);
		freqScope.inBus_(bus).background_(Color.black)
		.waveColors_([Color.magenta]);

		// phaseScope
		phaseScope = ScopeView(window,(ww/2)@(wh/2))
		.style_(2)
		.bufnum_(buffers[1].bufnum)
		.background_(Color.black).waveColors_([Color.blue]).yZoom_(0.5);
		// meterScopes
		meterScopes = Array.fill(2,{
			LevelIndicator.new(window,ww@23).warning_(0.8)
			.critical_(0.9).background_(Color.black).drawsPeak_(true);
		});
	}

	prStartScoping {
		synth = Synth.after(
			/*server,*/
			1,
			\PhaseScopeSynth,[
			\inBus, bus, \bufferA, buffers[0], \bufferB, buffers[1]
		]); // start Synth

		synth.moveToTail(RootNode(server));

		// a = RootNode(s);
		// "synth RootNode".warn;

		meterRout = fork{loop{ 	// update Amplitude Values
			meterBus.get({   // get current value from the bus
				arg busVal;
				2.do{ arg i;
					{  // set meterScopes' values
						meterScopes[i].value_(busVal.value[i]);
						meterScopes[i].peakLevel_(busVal.value[i]);
					}.defer;
				};
			});
			0.1.wait;
		}};
	}

	free {
		if(window.isClosed.not){ window.close };
	}

}





/////////////////////////////////


MyFancyStereoScope{
	var window;  // the parent window
	var waveScope, phaseScope, freqScope, meterScopes; // the scopes
	var buffers, meterBus, meterRout, synth; // used to update the scopes
	var <bus, <server; // the bus and server passed as arguments

	*new { arg bus = 0, server = Server.default;
		^super.new.init(bus,server);
	}

	init{ arg inBus, serv;
		bus = inBus;   // copy argument to variable
		server = serv; // copy argument to variable
		server.waitForBoot({ // wait for server to boot
			fork{
				buffers = Array.fill(2,{Buffer.alloc(server,1024,2)}); // allocate Buffers
				server.sync; // wait for server to sync

				meterBus = Bus.control(server,2); // allocate Bus
				server.sync; // wait for server to sync

				// add SynthDef
				SynthDef(\myFancyStereoScopeSynth,{
					arg inBus, bufferA, bufferB;
					var signal, amplitudes;
					signal = In.ar(inBus,2); // read input bus
					amplitudes = Amplitude.kr(signal);
					ScopeOut.ar(signal,bufferA); // scopeOut to bufferA
					ScopeOut.ar(signal,bufferB); // scopeOut to bufferB
					Out.kr(meterBus,amplitudes);
				}).add;
				server.sync; // wait for server to sync

				{   this.prMakeGui;  // call method to create gui
					this.prStartScoping; // call method to start scoping
				}.defer; // schedule on the AppClock
			};
		});
	}

	prMakeGui{ //herein we create and customize the GUI elements
		// parent window
		window = Window.new("MyFancyScope",800@640).front;
		window.addFlowLayout; // add flowlayout
		window.onClose_({ // on close
			freqScope.kill; // kill freqScope
			buffers.do{arg item; item.free}; // free Buffers
			meterRout.stop; // stop routine
			synth.free; // free Synth
		});
		// waveScope
		waveScope = ScopeView(window,790@230).style_(1).bufnum_(buffers[0].bufnum)
		.background_(Color.black).waveColors_([Color.red,Color.green])
		.yZoom_(0.5);
		// freqScope
		freqScope = FreqScopeView(window,393@340).active_(true);
		freqScope.inBus_(bus).background_(Color.black)
		.waveColors_([Color.magenta]);
		// phaseScope
		phaseScope = ScopeView(window,393@340).style_(2).bufnum_(buffers[1].bufnum)
		.background_(Color.black).waveColors_([Color.blue]).yZoom_(0.5);
		// meterScopes
		meterScopes = Array.fill(2,{
			LevelIndicator.new(window,790@23).warning_(0.8)
			.critical_(0.9).background_(Color.black).drawsPeak_(true);
		});
	}

	prStartScoping {
		synth = Synth.tail(server,\myFancyStereoScopeSynth,[
			\inBus, bus, \bufferA, buffers[0], \bufferB, buffers[1]
		]); // start Synth

		"synth RootNode".warn;

		meterRout = fork{loop{ 	// update Amplitude Values
			meterBus.get({   // get current value from the bus
				arg busVal;
				2.do{ arg i;
					{  // set meterScopes' values
						meterScopes[i].value_(busVal.value[i]);
						meterScopes[i].peakLevel_(busVal.value[i]);
					}.defer;
				};
			});
			0.1.wait;
		}};
	}

	free {
		if(window.isClosed.not){ window.close };
	}

}
