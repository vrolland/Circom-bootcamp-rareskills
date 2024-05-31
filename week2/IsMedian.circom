pragma circom 2.1.3;
include "../node_modules/circomlib/circuits/comparators.circom";

template IsSorted(n) {
    signal input in[n];

    component checkLessEqThan[n-1];
    for(var i = 0; i < n-1; i++) {
        checkLessEqThan[i] = LessEqThan(250);
        checkLessEqThan[i].in[0] <== in[i];
        checkLessEqThan[i].in[1] <== in[i+1];
        1 === checkLessEqThan[i].out;
    }
}

template IsMedian() {
    signal input in[5];
    signal input k;

    component isSortedCmp = IsSorted(5);
    isSortedCmp.in <== in;

    in[2] === k;
}

component main = IsMedian();
