.EQU BUFFER_START, 100
.EQU BUFFER_MAX, 116
.boot:
    IMM SP, 255
    IMM R1, 5
    IMM R2, 2
    MUL R3, R1, R2
    IMM R4, 10
    SUB R5, R3, R4
    IMM R0, 0
    BRE R5, R0, .load_os
    JMP .error_halt
.error_halt:
    IMM R1, 0xFF
    OUT 255, R1
    JMP .error_halt
.load_os:
    SUB R1, R1, R1
    SUB R2, R2, R2
    SUB R3, R3, R3
    SUB R4, R4, R4
    SUB R5, R5, R5
    JMP .print_prompt
.print_prompt:
    IMM R4, BUFFER_START
    IMM R1, 62
    OUT 2, R1
    IMM R1, 32
    OUT 2, R1
    JMP .wait_for_key
.wait_for_key:
    IN R1, 2
    BRE R1, R0, .wait_for_key
    JMP .wait_for_release
.wait_for_release:
    IN R3, 2
    BNE R3, R0, .wait_for_release
    IMM R2, 13
    BRE R1, R2, .parse_command
    IMM R2, 8
    BRE R1, R2, .handle_backspace
    IMM R2, BUFFER_MAX
    BRE R4, R2, .wait_for_key
    STORE [R4], R1
    OUT 2, R1
    ADD R4, R4, 1
    JMP .wait_for_key
.handle_backspace:
    IMM R2, BUFFER_START
    BRE R4, R2, .wait_for_key
    SUB R4, R4, 1
    STORE [R4], R0
    IMM R1, 8
    OUT 2, R1
    JMP .wait_for_key
.parse_command:
    IMM R1, 10
    OUT 2, R1
    LOAD R1, [BUFFER_START]
    IMM R2, 72
    BRE R1, R2, .CASE_HELP
    IMM R2, 86
    BRE R1, R2, .CASE_VERSION
    JMP .unknown_command
.CASE_HELP:
    IMM R1, 72
    OUT 2, R1
    IMM R1, 69
    OUT 2, R1
    IMM R1, 76
    OUT 2, R1
    IMM R1, 80
    OUT 2, R1
    IMM R1, 10
    OUT 2, R1
    JMP .print_prompt
.CASE_VERSION:
    IMM R1, 118
    OUT 2, R1
    IMM R1, 49
    OUT 2, R1
    IMM R1, 46
    OUT 2, R1
    IMM R1, 49
    OUT 2, R1
    IMM R1, 10
    OUT 2, R1
    JMP .print_prompt
.unknown_command:
    IMM R1, 63
    OUT 2, R1
    IMM R1, 10
    OUT 2, R1 
    JMP .print_prompt
