pragma circom 2.1.9;

include "../node_modules/circomlib/circuits/comparators.circom";

template HasAtLeastOne(n) {
    signal input in[n];
    signal input k;
    signal output out;

    signal temp[n];
    temp[0] <== (k - in[0]);
    for(var i = 1; i < n; i++) {
        temp[i] <== temp[i-1] * (k - in[i]);
    }

    // This doesn't feel right: it feels underconstraint
    // Can we provide a false inv in the witness that force "temp[n-1] * inv" to be 0 ?
    signal inv <-- 1 / temp[n-1];

    out <== 1 - temp[n-1] * inv;

}

template Max(n) {

    signal input in[n];
    signal output out;

    // Compute the max
    var currentMax = 0;
    for (var i = 0; i < n; i++) {
        if (in[i] > currentMax) {
            currentMax = in[i];
        }
    }
    // assign the max to the out WITH NO CONSTRAINTS
    out <-- currentMax;

    // Constraint: out must higher or equal to every inputs
    component let[n];
    for (var i = 0; i < n; i++) {
        let[i] = LessEqThan(250);
        let[i].in[0] <== in[i];
        let[i].in[1] <== out;
        1 === let[i].out;
    }

    // Constraint: out must be part of the inputs
    component halo = HasAtLeastOne(n);
    halo.in <== in;
    halo.k <== out;
    halo.out === 1;
}

component main = Max(6);