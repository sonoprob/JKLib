// smear
// mix in the undelayed audio for the first delay interval

CombN.ar(audio, delay, delay,0,1) + (audio * EnvGen.ar(Env.linen(0,delay, 0.001))


// I figured a variant of your multiplication proposal, that is
// (seems that with n + 0.6 one can work around a problem with precise Trig1 hold times)
dly + in * Trig1.ar(1, (n + 0.6) * SampleDur.ir)


// as I'm going to have a latch triggered in the end, actually the following my work in my case:
    dly + in * Impulse.ar(0)