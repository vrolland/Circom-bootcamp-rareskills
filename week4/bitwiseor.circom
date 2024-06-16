pragma circom 2.1.6;

template BitwiseOR(n) {
	signal input in[2][n]; // 2 n-bit inputs
	signal output out[n];

    for(var i=0; i < n; i++) {
        (1-in[0][i]) * in[0][i] === 0;
        (1-in[1][i]) * in[1][i] === 0;

        out[i] <== in[0][i] + in[1][i] - in[0][i] * in[1][i];
    }
}

component main = BitwiseOR(4);


