pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Use the same constraints from IntDiv, but this
// time assign the quotient in `out`. You still need
// to apply the same constraints as IntDiv

template IntDivOut(n) {
    signal input numerator;
    signal input denominator;
    signal output out;

    signal quotient;
    signal remainder;

    quotient <-- numerator \ denominator;
    remainder <-- numerator % denominator;

    // Constraint: denominator * quotient === numerator - remainder
    component isEqQ = IsEqual();
    isEqQ.in[0] <== denominator * quotient;
    isEqQ.in[1] <== numerator - remainder;
    isEqQ.out === 1;

    // Constraint: remainder must lower than denominator
    component let = LessThan(n);
    let.in[0] <== remainder;
    let.in[1] <== denominator;
    let.out === 1;

    // Constraint: denominator is not Zero
    component isZ = IsZero();
    isZ.in <== denominator;
    isZ.out === 0;

    out <== quotient;
}

component main = IntDivOut(252);
