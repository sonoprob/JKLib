(

Tdef(
	PavillionArc2.asSymbol,
	{|env|
		var a, b, amp, delta;
		env.accamt = 64;
		env.accexp = rrand(0.9, 0.99);
		env.accwait = rrand(1, 9);
		env.accmul = 1;
		env.aconst = 0.25;
		env.bconst = 1;
		env.afact = 0.001;
		env.bfact = 0.003;
		env.wrap = true;
		env.accelaration = 0;
		env.deccelaration = 0;
		env.regular = 1;
		env.doubleAcceleration = false;

		env.accamt = 64;
		env.accexp = rrand(0.9, 0.99);
		env.accwait = rrand(1, 9);
		env.accmul = 1;
		env.aconst = 0.25;
		env.bconst = 1;
		env.afact = 0.001;
		env.bfact = 0.003;

		env.accamtd = 0.1;
		env.accexpd = 0.1;
		env.accwaitd = 0.1;
		env.accmuld = 0.1;
		env.aconstd = 0.1;
		env.bconstd = 0.1;
		env.afactd = 0.1;
		env.bfactd = 0.1;

		env.wrap = true;
		env.accelaration = 0;
		env.deccelaration = 0;
		env.regular = 1;
		env.doubleAcceleration = false;

		inf.do{

			env.accamt = rrand( env.accamt * (1 - env.accamtd), env.accamt * (1 + env.accamtd)).round.abs;
			env.accexp = rrand( env.accexp * (1 - env.accexpd), env.accexp * (1 + env.accexpd)).abs;
			env.accwait = rrand( env.accwait * (1 - env.accwaitd), env.accwait * (1 + env.accwaitd)).abs;
			env.accmul = rrand( env.accmul * (1 - env.accmuld), env.accmul * (1 + env.accmuld)).abs;
			env.aconst = rrand( env.aconst * (1 - env.aconstd), env.aconst * (1 + env.aconstd)).abs;
			env.bconst = rrand( env.bconst * (1 - env.bconstd), env.bconst * (1 + env.bconstd)).abs;
			env.afact = rrand( env.afact * (1 - env.afactd), env.afact * (1 + env.afactd)).abs;
			env.bfact = rrand( env.bfact * (1 - env.bfactd), env.bfact * (1 + env.bfactd)).abs;

			env.accamt.do{| i |
				a = env.aconst + (i * env.afact);
				b = env.bconst - (i * env.bfact);

				// if(env.wrap){
				// 	a = a.wrap(0,1);
				// 	b = b.wrap(0,1);
				// }{
				// 	a = a.fold(0,1);
				// 	b = b.fold(0,1);
				// };

				amp = exprand(0.3,8);
				// Synth(\sinesweep1,[\a, a, \b, b, \amp, amp ], target:PavillionArc2.group);
				Synth.grain(\sinesweep1,[\a, a, \b, b, \amp, amp ], target: PavillionArc2.group, addAction: \addToHead);

				amp = exprand(0.3,8);
				// Synth(\sinesweeplong,[\a, a, \b, b, \amp, amp/2], target:PavillionArc2.group);
				// Synth(\sinesweeprev,[\a, a, \b, b, \amp, amp ], target:PavillionArc2.group);
				// Synth(\sinesweep2,[\a, a, \b, b, \amp, amp ], target:PavillionArc2.group);
				Synth.grain(\sinesweep2,[\a, a, \b, b, \amp, amp ], target: PavillionArc2.group, addAction: \addToHead);

				delta = (env.accmul * (0.5 * ( env.accexp ** i)));

				if( env.doubleAcceleration == true ){
					delta = delta *
					[ (1/(1.618 ** i)), (1/(0.618 ** i)/40), 1]
					.wchoose(
						[ env.acceleration, env.deccelaration, env.regular].normalizeSum
					);
				};

				delta.wait

			};

			(env.accwait * [0.5,1,1,2,3].choose).wait;
		}
});

)


Tdef(\PavillionArc2).play;


s.queryAllNodes;


PavillionArc2.t.set( 'deccelaration', 0, 'accwait', 8, 'aconst', 0.25, 'accmul', 1,
	'accexp', 0.90742604970932, 'wrap', true, 'accamt', 64, 'regular', 1, 'doubleAcceleration', false,
	'bconst', 1, 'accelaration', 0, 'bfact', 0.003, 'afact', 0.001
)



(
// Tdef(\PavillionArc2)
PavillionArc2.t.set(
	\accamt, 64,
	\accexp, rrand(0.9, 0.99),
	\accwait, 1,
	\accmul, 1,
	\aconst, 0.25,
	\bconst, 1,
	\afact, 0.001,
	\bfact, 0.003,
	\wrap, true,
	\accelaration, 0,
	\deccelaration, 0,
	\regular, 1,
	\doubleAcceleration, false,

	\accamt, 64,
	\accexp, rrand(0.9, 0.99),
	\accwait, rrand(1, 9),
	\accmul, 1,
	\aconst, 0.25,
	\bconst, 1,
	\afact, 0.001,
	\bfact, 0.003,

	\accamtd, 0.1,
	\accexpd, 0.1,
	\accwaitd, 0.1,
	\accmuld, 0.1,
	\aconstd, 0.1,
	\bconstd, 0.1,
	\afactd, 0.1,
	\bfactd, 0.1,

	\wrap, true,
	\accelaration, 0,
	\deccelaration, 0,
	\regular, 1,
	\doubleAcceleration, false
)
)


???
(
PavillionArc2.t.set(
	\accamt, 9,\accamtd, 0.9,
	\aconstd, 0,\afactd, 0, \bconstd, 0,\bfactd, 0,
	\accexp, 0.92,\accexpd, 0.03,
	\accmul, 0.9,\accmuld, 0.2,
	\accwait, 0,\accwaitd, 0,
)

)

PavillionArc2.t.set(\accmul, 1, \accamt, 123, \accwait, 1, \accexp, 0.9)

PavillionArc2.t.set(\accamt, 3, \accwait, 0);

PavillionArc2.t.set(\accamt, 3, \accwait, 0);

PavillionArc2.t.set(\aconst, 0.1, \afact, 0.05, \bconst, 0, \bfact, 0.02, \wrap, true)

PavillionArc2.t.set(\accamt, 230, \accexp, 0.97)

PavillionArc2.t.set(\accamt, 530, \accexp, 0.95)

PavillionArc2.t.set(\accamt, 30, \accexp, 1.02, \accmul, 0.01)

PavillionArc2.t.set(\accamt, 80, \accexp, 1.03, \accmul, 0.01)

PavillionArc2.t.set(\accamt, 300, \accexp, 1.02, \accmul, 0.01)

PavillionArc2.t.set(\accamt, 200, \accexp, 1.03, \accmul, 0.01, \accwait, 0)



PavillionArc2.fxGroup.set(\dly, 0.1)


(
Tdef(\PavillionArc2).set(
	\accamt, 32,
	\accexp, 0.97,
	\accwait, 0,
	\accmul, 0.01,
	\aconst, 0.25,
	\bconst, 0,
	\afact, 0.001,
	\bfact, 0.003,
	\wrap, true,
	\accelaration, 0,
	\deccelaration, 0,
	\regular, 1,
	\doubleAcceleration, false,
	\accamt, 64,
	\accexp, rrand(0.9, 0.99),
	\accwait, rrand(1, 9),
	\accmul, 1,
	\aconst, 0.25,
	\bconst, 1,
	\afact, 0.001,
	\bfact, 0.003,

	\accamtd, 0.9,
	\accexpd, 0,
	\accwaitd, 0.1,
	\accmuld, 0.1,
	\aconstd, 0.1,
	\bconstd, 0.1,
	\afactd, 0.1,
	\bfactd, 0.1,

	\wrap, true,
	\accelaration, 0,
	\deccelaration, 0,
	\regular, 1,
	\doubleAcceleration, false
)
)

