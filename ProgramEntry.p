DEFINE VARIABLE cProgID AS CHARACTER   NO-UNDO INIT "airrcashflow".
DEFINE VARIABLE cDescription AS CHARACTER   NO-UNDO INIT "AR Cash Flow Report".

DEFINE VARIABLE lCreate AS LOGICAL     NO-UNDO INIT FALSE.

IF lCreate THEN DO:
    create program.

    assign program.prog_id = cProgID
        program.description = cDescription.

END.
ELSE DO:
    FIND program WHERE program.prog_id = cProgID EXCLUSIVE.
    DELETE program.
END.
