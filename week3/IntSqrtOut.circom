pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Be sure to solve IntSqrt before solving this 
// puzzle. Your goal is to compute the square root
// in the provided function, then constrain the answer
// to be true using your work from the previous puzzle.
// You can use the Bablyonian/Heron's or Newton's
// method to compute the integer square root. Remember,
// this is not the modular square root.


function intSqrtFloor(n) {
    // compute the floor of the
    // integer square root

    // From ChatGpt: Newton's Method (Heron's Method) 
    if (n == 0 || n == 1) {
        return n;
    }

    var x = n;
    var y = (x + 1) \ 2;
    while(y < x) {
        x = y;
        y = (x + n \ x) \ 2;
    }

    return x;
}

template IntSqrtOut(n) {
    signal input in;
    signal output out;

    out <-- intSqrtFloor(in);

    // Constraint: (b - 1)(b - 1) < a
    component lt = LessThan(n);
    lt.in[0] <== (out-1) * (out-1);
    lt.in[1] <== in;
    lt.out === 1;

    // Constraint: (b + 1)(b + 1) > a
    component get = GreaterThan(n);
    get.in[0] <== (out+1) * (out+1);
    get.in[1] <== in;
    get.out === 1;

    // Constraint: avoid overflow
    component let = LessThan(n);
    let.in[0] <== out;
    let.in[1] <== 2 ** (n/2);
    let.out === 1;
}

component main = IntSqrtOut(252);
