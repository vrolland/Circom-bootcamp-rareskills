pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/multiplexer.circom";
include "../node_modules/circomlib/circuits/comparators.circom";


template Stack(maxSteps, maxStackHeight, n) {
    // 0: opcode, 1: value
    // opcode: 0 NOP, 1 PUSH
    signal input operations[maxSteps][2];

    signal input indexRow;
    signal input indexColumn;
    signal input value;

    signal topStack[maxSteps+1];
    signal valueToPush[maxSteps];
    signal valueToPush2[maxSteps][maxStackHeight];
    signal stack[maxSteps+1][maxStackHeight];

    // Initiate stack with 0
    for (var j = 0; j < maxStackHeight; j++) {
        stack[0][j] <== 0;
    }
    topStack[0] <== 0;

    // opcode must be 0 or 1
    for(var k = 0; k < maxSteps; k++) {
        operations[k][0] * (operations[k][0] -1) === 0;
    }

    component isBeforeTopStack[maxSteps][maxStackHeight];
    component isAtTopStack[maxSteps][maxStackHeight];

    // All pushes
    for (var i = 1; i < maxSteps+1; i++) {
        // avoid non quadratic mess
        valueToPush[i-1] <== operations[i-1][1] * operations[i-1][0];

        for (var j = 0; j < maxStackHeight; j++) {
            isBeforeTopStack[i-1][j] = LessThan(n);
            isBeforeTopStack[i-1][j].in[0] <== j;
            isBeforeTopStack[i-1][j].in[1] <== topStack[i-1];
            // isBeforeTopStack[i-1][j].out;

            isAtTopStack[i-1][j] = IsEqual();
            isAtTopStack[i-1][j].in[0] <== j;
            isAtTopStack[i-1][j].in[1] <== topStack[i-1];
            // isAtTopStack[i-1][j].out;

            // avoid non quadratic mess
            valueToPush2[i-1][j] <== isAtTopStack[i-1][j].out * valueToPush[i-1];

            stack[i][j] <== 
                isBeforeTopStack[i-1][j].out * stack[i-1][j]
                +
                // If opcode is 1 (PUSH) => copy value the top stack
                // If opcode is 0 (NOP) => copy 0 
                // isAtTopStack[i-1][j].out * valueToPush[i-1]
                valueToPush2[i-1][j];
        }
        
        topStack[i] <== topStack[i-1] + operations[i-1][0];
        
    }

    // Get the stack at index "indexColumn"
    component multiStep = Multiplexer(maxStackHeight, maxSteps+1);
    multiStep.inp <== stack;
    multiStep.sel <== indexColumn;


    // Get the value in the stack at index "indexRow"
    component multiStack = Multiplexer(1, maxStackHeight);
    for(var k = 0; k < maxStackHeight; k++) {
        multiStack.inp[k] <== [multiStep.out[k]];
    }
    multiStack.sel <== indexRow;

    // Check if the value is right
    value === multiStack.out[0];
}


component main = Stack(3, 3, 252);
