
pragma circom 2.1.6;

template BitwiseAdd(n) {
	signal input in[2][n]; // 2 n-bit inputs
	signal output out[n];
    signal t[n+1];
    signal t2[n+1];
    signal carry[n+1];

    // First carry is always 0
    carry[0] <== 0;

    for(var i=0; i < n; i++) { 
        // Only binary here!
        (1-in[0][i]) * in[0][i] === 0;
        (1-in[1][i]) * in[1][i] === 0;
        (1-carry[i]) * carry[i] === 0;

        // Signals to keep it quadratic
        // Temporary signal to get the integer addition of the inputs and the carry
        t[i] <== in[0][i] + in[1][i] + carry[i];
        t2[i] <== t[i] * t[i];


        // Computes the next carry (lagrange interpolation used here)
        // carry[i+1] = 1, if t[i] == 2 or 3
        // carry[i+1] = 0, if t[i] == 0 or 1q
        // carry[i+1] <== (t[i]*(t[i]-1)*(-2*t[i]+7)) / 6;
        carry[i+1] <== (-2 * t2[i] * t[i] + 9 * t2[i] - 7 * t[i]) / 6;

        // Computes the result (lagrange interpolation used here)
        // tempout[i] = 1, if t[i] == 1 or 3
        // tempout[i] = 0, if t[i] == 0 or 2
        // out[i] <== (t[i]*(t[i]-2)*(4*t[i]-10)) / 6;
        out[i] <== (4 * t2[i] * t[i] - 18 * t2[i] + 20 * t[i]) / 6;
    }
}

component main = BitwiseAdd(4);
