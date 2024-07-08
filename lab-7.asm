.ORIG x3000

MAIN

    LD R1 INS_PTR
    LD R0 GET_INPUT_PTR
    JSRR R0
    
    LD R2 INS_PTR
    LD R4 MEM_PTR
    AND R5 R5 #0
    
    
    AND R1 R1 #0
    ADD R1 R1 #-1
    AND R3 R3 #0
    
    
    PROCESS_INS
        LDR R0 R2 #0
        
        ADD R6 R0 #-1
        BRz PROCESS_MOVE_RIGHT
        ADD R6 R6 #-1
        BRz PROCESS_MOVE_LEFT
        ADD R6 R6 #-1
        BRz PROCESS_INC
        ADD R6 R6 #-1
        BRz PROCESS_DEC
        ADD R6 R6 #-1
        BRz PROCESS_OUT
        ADD R6 R6 #-1
        BRz PROCESS_IN
        ADD R6 R6 #-1
        BRz PROCESS_LOOP_ENTER
        ADD R6 R6 #-1
        BRz PROCESS_LOOP_EXIT
        ADD R6 R6 #-1
        BRz PROCESS_EOF
        BRnp END_PROCESS_INS
        
        PROCESS_MOVE_RIGHT
        ADD R4 R4 #1
        ADD R2 R2 #1
        
        LDR R6 R2 #0
        ADD R0 R6 #-1
        BRz PROCESS_MOVE_RIGHT
        BRnp PROCESS_INS
        
        PROCESS_MOVE_LEFT
        ADD R4 R4 #-1
        ADD R2 R2 #1
        BRnzp PROCESS_INS
        
        PROCESS_INC
        LDR R0 R4 #0
        ADD R0 R0 #1
        STR R0 R4 #0
        ADD R2 R2 #1
        
        LDR R6 R2 #0
        ADD R0 R6 #-3
        BRz PROCESS_INC
        BRnp PROCESS_INS
        
        PROCESS_DEC
        LDR R0 R4 #0
        ADD R0 R0 #-1
        STR R0 R4 #0
        ADD R2 R2 #1
        
        LDR R6 R2 #0
        ADD R0 R6 #-4
        BRz PROCESS_DEC
        BRnp PROCESS_INS
        
        PROCESS_OUT
        LDR R0 R4 #0
        OUT
        ADD R2 R2 #1
        BRnzp PROCESS_INS
        
        
        PROCESS_IN
        GETC
        STR R0 R4 #0
        ADD R2 R2 #1
        BRnzp PROCESS_INS
        
        
        
        PROCESS_LOOP_ENTER
        LD R0 HANDLE_LOOP_ENTER_PTR
        JSRR R0
        ADD R2 R2 #1
        BRnzp PROCESS_INS
        
        
        
        PROCESS_LOOP_EXIT
        LD R0 HANDLE_LOOP_EXIT_PTR
        JSRR R0
        ADD R2 R2 #1
        
        LDR R6 R2 #0
        ADD R0 R6 #-8
        BRz PROCESS_LOOP_EXIT
        BRnp PROCESS_INS
        
        
        PROCESS_EOF
        
    END_PROCESS_INS
    
    
    
    
    HALT
    HANDLE_LOOP_ENTER_PTR   .FILL HANDLE_LOOP_ENTER
    HANDLE_LOOP_EXIT_PTR    .FILL HANDLE_LOOP_EXIT
    GET_INPUT_PTR           .FILL GET_INPUT
    MEM_PTR                 .FILL MEM
    INS_PTR                 .FILL INS
    
    INS                     .BLKW #1000
    MEM                     .BLKW #1000
    
END_MAIN

HANDLE_LOOP_ENTER
    LDR R6 R4 #0
    BRnp LOOP_ENTER_STACK
    LOOP_ENTER_COMMENT
        ADD R5 R5 #1
        LOOP_ENTER_COMMENT_LOOP
            ADD R2 R2 #1
            LDR R0 R2 #0
            ADD R6 R0 #-7
            BRnp LOOP_ENTER_COMMENT_LOOP_CONTINUE
            ADD R5 R5 #1
            BRnzp LOOP_ENTER_COMMENT_LOOP
            
            LOOP_ENTER_COMMENT_LOOP_CONTINUE
            ADD R6 R0 #-8
            BRnp LOOP_ENTER_COMMENT_LOOP
            ADD R5 R5 #-1
            BRz DONE_HANDLE_LOOP_ENTER
            BRnp LOOP_ENTER_COMMENT_LOOP
    
    LOOP_ENTER_STACK
        ADD R1 R1 #1
        LEA R3 STACK
        ADD R3 R3 R1
        STR R2 R3 #0

    DONE_HANDLE_LOOP_ENTER
    RET
    STACK                   .BLKW #50
    
END_HANDLE_LOOP_ENTER



HANDLE_LOOP_EXIT
    LDR R6 R4 #0
    BRz HANDLE_LOOP_EXIT_LOOP_POP_STACK
    BRnp HANDLE_LOOP_EXIT_LOOP_BACK
    
    HANDLE_LOOP_EXIT_LOOP_POP_STACK
        LEA R3 STACK
        ADD R3 R3 R1
        
        AND R6 R6 #0
        STR R6 R3 #0
        
        ADD R1 R1 #-1
        
        BRnzp DONE_HANDLE_LOOP_EXIT
        
        
    HANDLE_LOOP_EXIT_LOOP_BACK

        LEA R3 STACK
        ADD R3 R3 R1
        
        LDR R6 R3 #0
        ADD R2 R6 #0
    
    DONE_HANDLE_LOOP_EXIT
    RET

END_HANDLE_LOOP_EXIT





GET_INPUT

READ_INPUT
        GETC
        OUT
        
        LD R6 WHITE_SPACE_NEG
        ADD R6 R0 R6
        BRz READ_INPUT
        
        CHECK_RIGHT
        LD R5 MOVE_RIGHT_NEG
        ADD R5 R0 R5
        BRnp CHECK_LEFT
        ADD R5 R5 #1
        STR R5 R1 #0
        ADD R1 R1 #1
        BRnzp READ_INPUT
        
        CHECK_LEFT
        LD R5 MOVE_LEFT_NEG
        ADD R5 R0 R5
        BRnp CHECK_INC
        ADD R5 R5 #2
        STR R5 R1 #0 
        ADD R1 R1 #1
        BRnzp READ_INPUT
        
        CHECK_INC
        LD R5 INC_SIGN_NEG
        ADD R5 R0 R5
        BRnp CHECK_DEC
        ADD R5 R5 #3
        STR R5 R1 #0
        ADD R1 R1 #1
        BRnzp READ_INPUT
        
        CHECK_DEC
        LD R5 DEC_SIGN_NEG
        ADD R5 R0 R5
        BRnp CHECK_OUTPUT
        ADD R5 R5 #4
        STR R5 R1 #0
        ADD R1 R1 #1
        BRnzp READ_INPUT
        
        CHECK_OUTPUT
        LD R5 OUTPUT_SIGN_NEG
        ADD R5 R0 R5
        BRnp CHECK_INPUT
        ADD R5 R5 #5
        STR R5 R1 #0
        ADD R1 R1 #1
        BRnzp READ_INPUT
        
        CHECK_INPUT
        LD R5 INPUT_SIGN_NEG
        ADD R5 R0 R5
        BRnp CHECK_LOOP_ENTER
        ADD R5 R5 #6
        STR R5 R1 #0
        ADD R1 R1 #1
        BRnzp READ_INPUT
        
        CHECK_LOOP_ENTER
        LD R5 LOOP_ENTER_SIGN_NEG
        ADD R5 R0 R5
        BRnp CHECK_LOOP_EXIT
        ADD R5 R5 #7
        STR R5 R1 #0
        ADD R1 R1 #1
        BRnzp READ_INPUT
        
        CHECK_LOOP_EXIT
        LD R5 LOOP_EXIT_SIGN_NEG
        ADD R5 R0 R5
        BRnp CHECK_EOF
        ADD R5 R5 #8
        STR R5 R1 #0
        ADD R1 R1 #1
        BRnzp READ_INPUT
        
        CHECK_EOF
        LD R5 EOF_SIGN_NEG
        ADD R5 R0 R5
        BRnp READ_INPUT
        ADD R5 R5 #9
        STR R5 R1 #0
        
    END_READ_INPUT
    
    RET
    WHITE_SPACE_NEG         .FILL #-32
    
    MOVE_RIGHT_NEG          .FILL #-62
    MOVE_LEFT_NEG           .FILL #-60
    INC_SIGN_NEG            .FILL #-43        
    DEC_SIGN_NEG            .FILL #-45
    OUTPUT_SIGN_NEG         .FILL #-46
    INPUT_SIGN_NEG          .FILL #-44
    LOOP_ENTER_SIGN_NEG     .FILL #-91
    LOOP_EXIT_SIGN_NEG      .FILL #-93
    EOF_SIGN_NEG            .FILL #-126

END_GET_INPUT

.END
