pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Create a circuit that is satisfied if `numerator`,
// `denominator`, `quotient`, and `remainder` represent
// a valid integer division. You will need a comparison check, so
// we've already imported the library and set n to be 252 bits.
//
// Hint: integer division in Circom is `\`.
// `/` is modular division
// `%` is integer modulus

template IntDiv(n) {
    signal input numerator;
    signal input denominator;
    signal input quotient;
    signal input remainder;

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
}

component main = IntDiv(252);
