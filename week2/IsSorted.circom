pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Write a circuit that constrains the 4 input signals to be
// sorted. Sorted means the values are non decreasing starting
// at index 0. The circuit should not have an output.

template IsSorted() {
    signal input in[4];

    component checkLessEqThan[3];
    for(var i = 0; i < 3; i++) {
        checkLessEqThan[i] = LessEqThan(250);
        checkLessEqThan[i].in[0] <== in[i];
        checkLessEqThan[i].in[1] <== in[i+1];
        1 === checkLessEqThan[i].out;
    }

}

component main = IsSorted();
