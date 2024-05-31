pragma circom 2.1.8;

// Create a circuit that takes an array of signals `in[n]` and
// a signal k. The circuit should return 1 if `k` is in the list
// and 0 otherwise. This circuit should work for an arbitrary
// length of `in`.

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

component main = HasAtLeastOne(4);
