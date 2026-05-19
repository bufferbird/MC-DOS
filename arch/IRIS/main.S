.EQU BUFFER_START, 1024
.EQU BUFFER_MAX, 1056

.boot:
    IMM SP, 8192
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
    IMM R20, .string_prompt
    IMM R21, .string_help_msg
    IMM R22, .string_version_msg
    IMM R23, .string_unknown_msg
    JMP .print_prompt

.print_prompt:
    IMM R4, BUFFER_START
    MOV R25, R20
    IMM R26, .wait_for_key
    JMP .syscall_print_string

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
    IMM R2, 67
    BRE R1, R2, .CASE_CLEAR
    JMP .unknown_command

.CASE_HELP:
    MOV R25, R21
    IMM R26, .print_prompt
    JMP .syscall_print_string

.CASE_VERSION:
    MOV R25, R22
    IMM R26, .print_prompt
    JMP .syscall_print_string

.unknown_command:
    MOV R25, R23
    IMM R26, .print_prompt
    JMP .syscall_print_string

.CASE_CLEAR:
    IMM R2, 100
.clear_loop:
    IMM R1, 8
    OUT 2, R1
    SUB R2, R2, 1
    BNE R2, R0, .clear_loop
    JMP .print_prompt


.syscall_print_string:
    LOAD R1, [R25]
    BRE R1, R0, .syscall_print_string_done
    OUT 2, R1
    ADD R25, R25, 1
    JMP .syscall_print_string
.syscall_print_string_done:
    JMP R26


.string_prompt:
    .DB 62, 32, 0          ; "> "
.string_help_msg:
    .DB 72, 69, 76, 80, 10, 0 ; "HELP\n"
.string_version_msg:
    .DB 77, 67, 45, 68, 79, 83, 32, 118, 49, 46, 49, 10, 0 ; "MC-DOS v1.1\n"
.string_unknown_msg:
    .DB 63, 10, 0          ; "?\n"

