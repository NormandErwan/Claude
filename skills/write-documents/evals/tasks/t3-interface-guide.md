Write a user guide for the "Run planner" screen of our internal lab tool, to `outputs/run-planner-guide.md`. The readers are lab technicians who start using the tool next week. They know their instruments and their samples well. They have never planned a designed experiment.

What the screen does: a technician lists the factors they want to vary (for example temperature, pressure, catalyst amount), gives each factor its low and high value, and the tool generates the list of runs to perform. The technician then runs them on the instrument, types each result into the table, and the tool shows which factors matter.

Screen layout, top to bottom:
- A "Factors" panel: one row per factor with three fields - Name, Low, High - and a "+ Add factor" button. Up to 7 factors.
- A "Design" drop-down with three choices: "Full factorial", "Half fraction", "Screening (Plackett-Burman)".
- A "Generate runs" button.
- A "Runs" table: one row per run, one column per factor showing "low" or "high", then an empty "Result" column the technician fills in. A "Randomize order" checkbox above it is ticked by default.
- An "Effects" chart under the table, filled once every result is entered: one horizontal bar per factor, its length the estimated effect on the result, bars sorted longest first, and a vertical dashed line marking the threshold above which an effect is considered real.

Number of runs each design generates, for k factors:
- Full factorial: 2^k runs - 3 factors: 8 runs; 5 factors: 32; 7 factors: 128.
- Half fraction: 2^(k-1) runs - 3 factors: 4; 5 factors: 16; 7 factors: 64. It cannot separate some combined effects of two factors from the effect of a third.
- Screening (Plackett-Burman): the next multiple of 4 above k - 3 factors: 4; 5 factors: 8; 7 factors: 8. It only estimates each factor's own effect, never combined effects.

Notes from the statistician who built it:
- Randomize the run order unless the instrument physically cannot change a factor between runs (for example an oven that takes an hour to change temperature). A fixed order lets instrument drift during the day pass for a factor effect.
- An "effect" is the average result at the high value minus the average result at the low value.
- Her test data, 3 factors, full factorial, yield in %: (temperature, pressure, catalyst) = (low, low, low) 64; (high, low, low) 77; (low, high, low) 67; (high, high, low) 80; (low, low, high) 65; (high, low, high) 76; (low, high, high) 68; (high, high, high) 79.
- Start with Screening when there are 5 or more factors and runs are expensive, then rerun a Full factorial on the 2 or 3 factors that came out above the threshold.
