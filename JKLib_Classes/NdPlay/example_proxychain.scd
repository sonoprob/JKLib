
(
q = q ? ();

q.numChans = 5;

        // add a sound source
ProxyChain.add(
    \dust, \mix -> { |dens=20, dustdec=0.02, dustfreq= 600|
        Ringz.ar(Dust.ar(dens).lag(0.0001), dustfreq, dustdec)
    }
);

        // an association with \filter becomes a filter,
        // and creates a wet/dry balance on the output.
        // several funcs can be added as key1, func1, key2, type -> func2, etc.
ProxyChain.add(
    \ringmod, \filter -> { |in, randrate=5|
        in.asArray[0]     // force mono inputs
        * SinOsc.ar(LFNoise0.kr([randrate, randrate]).exprange(300, 3000)).sum
    },
    \dist, \filter -> { |in, drive=10, amp=0.2| (in.asArray[0] * drive).clip2(0.5) * amp }
);

        // an association with \filterIn also becomes a filter,
        // but creates the wet/dry balance control on the filter input,
        // on on the output like \filter. this can be useful for delays, reverbs etc.
ProxyChain.add(
    \riseComb5, \filterIn -> { arg in, delay = 0.023, dlDrift = 0.02, spread=0.5,
        decayRise=0.5, decayFall=100;

        var delayscales = 2 ** ((0 .. q.numChans - 1) * 2 / (q.numChans - 1) - 1 * spread);

        var dels = delayscales.scramble.collect { |dscale|

            var timedrift = LFDNoise3.kr(0.3, dlDrift, 1) * dscale;
            var ampcomp = (20 * decayRise).dbamp * (decayFall ** -0.25);

            var combs;
            in = in.asArray[0] * ampcomp.lag(0.2);
            combs = (decayFall * [ 1, decayRise]).collect { |decay|
                CombL.ar(in, 1, delay * dscale, decay * delay)
            };
            combs[0] - combs[1];    // combs come in slowly, like formlet.

        };
        Splay.ar(dels)
    },
    \ampFin, \filter -> { |in, drive=1, ampLimit=1, lAmp=1|
        Limiter.ar(in * drive, ampLimit) * lAmp;
    }
);

    // add specs for the controls used (for NodeProxyEditor).
Spec.add(\dens, [0.1, 1000, \exp]);
Spec.add(\dustamp, [0, 1, \amp]);
Spec.add(\dustdec, [0.0001, 0.1, \exp]);
Spec.add(\dustfreq, \freq);

Spec.add(\dt, [0.001, 0.2, \exp]);
Spec.add(\dc, [0.01, 100, \exp]);

Spec.add(\drive, [1, 100, \exp]);

Spec.add(\spread, [0, 1, \amp]);
Spec.add(\decayRise, [0, 0.9, \amp]);
Spec.add(\decayFall, [1, 1000, \exp]);
Spec.add(\dlDrift, [0, 0.1, \amp]);

s.boot;
)



///////////////////


(
s.boot;

// define which FX are going to be used.
// As MasterFX is based on ProxyChain, these FX are the same as in ProxyChain.
ProxyChain.add(
    \leakDC,  \filter -> { |in, leak=0.99| LeakDC.ar(in, leak) },
    \rollClip, \filter -> { |in, clip=0.99, pole=0.2|
        OnePole.ar(in.clip2(clip), pole ** 0.7);
    },
    \krush, \filter -> { |in, bits=16, downsamp=2|
        var down;
        in = in.round(0.5 ** bits);
        down = Latch.ar(in, Impulse.ar(SampleRate.ir / downsamp.max(2)));
        // below 1/2 downsamp, do xfade:
        blend(in, down, (downsamp - 1).clip(0, 1));
    },
    \ampFin, \filter -> { |in, limDrive=1, ampLimit=0.8, postAmp=1 |
        Limiter.ar(in * limDrive, ampLimit) * postAmp;
    }
);

// and specs for them (e.g. for gui control)
Spec.add(\leak, [0.5, 0.999, \exp]);
Spec.add(\clip, [0.0, 1, \amp]);
Spec.add(\pole, [0, 0.95, \lin]);
Spec.add(\bits, [16, 1]);
Spec.add(\downsamp, [1, 100, \exp]);
Spec.add(\limDrive, \ampx4);
Spec.add(\ampLimit, \amp);
Spec.add(\postAmp, \ampx4);
)


(
// An 8-channel MasterFX on server s.
// The order in slotNames determines order of execution of the efx.
m = MasterFX.new(server: s,
    numChannels: 8,
    slotNames: [\leakDC, \krush, \rollClip, \ampFin],
    busIndex: 0
);

g = m.gui; // a GUI
s.scope(8);
)

// a test signal
x = { PinkNoise.ar(0.5) * LFNoise2.kr([5, 8, 13, 21]).max(0); }.play;


// all MasterFX live here:
MasterFX.all;

// kick in predefined effects (at full wet level)
m.add(\leakDC, 1);
m.add(\rollClip, 1);
m.add(\dualComp, 1);
m.add(\ampFin, 1);

// kick out predefined effects (at full wet level)
m.remove(\leakDC);
m.remove(\rollClip);
m.remove(\krush);
m.remove(\ampFin);


(
// make a more specific GUI - see ProxyChainGui for details
m.gui(\Mestre, 20, [
    [\leakDC, \slotCtl, 1],
    [\rollClip, \slotCtl, 1],
    [\krush, \slotCtl, 1],
    [\ampFin, \slotCtl, 1],
    [\RESET, \extra, { m.pxChain.add(\leakDC, 1).add(\ampFin, 1) }],
])
)


// make a MasterFX on the internal server
MasterFX(Server.internal, 8, [\leakDC, \rollClip, \dualComp, \ampFin]);

// now there are two MasterFX, one localhost, one internal
MasterFX.all;

// removing a MasterFX by server name
MasterFX.clear(\localhost); // clear one specific masterfx

// or simply by
m.clear

// or clear all MasterFX
MasterFX.clear; // clear all mfxes


// all gone now:
MasterFX.all;