pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/multiplexer.circom";


template Stack(maxSteps, maxStackHeight) {
    signal input pushValues[maxSteps];

    signal input indexRow;
    signal input indexColumn;
    signal input value;


    // Initiate stack with 0
    signal stack[maxSteps+1][maxStackHeight];
    for (var j = 0; j < maxStackHeight; j++) {
        stack[0][j] <== 0;
    }

    // All pushes
    var stackTop = 0;
    for (var i = 1; i < maxSteps+1; i++) {
        // Before stackTop copy previous stack
        for (var j = 0; j < stackTop; j++) {
            stack[i][j] <== stack[i-1][j];
        }

        // Copy at the stackTop the value pushed
        stack[i][stackTop] <== pushValues[i-1];

        // Initialize to zero the rest of the stack
        for (var k = stackTop+1; k < maxStackHeight; k++) {
            stack[i][k] <== 0;
        }

        // Update the stack top
        stackTop += 1;
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


component main = Stack(3, 3);
