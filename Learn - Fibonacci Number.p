/* using int64 as regular integer will not work */

DEFINE VARIABLE ifib1 AS int64 INITIAL 1.   /* Fibonacci number temporaries */
DEFINE VARIABLE ifib2 AS INT64 INITIAL 1.
DEFINE VARIABLE ifib3 AS INT64 INITIAL 1.
DEFINE VARIABLE ioutput AS INTEGER INITIAL 1.  /* Transactional variables */
DEFINE VARIABLE icount AS INTEGER no-undo INITIAL 3.
DEFINE VARIABLE again AS LOG INITIAL TRUE.


RUN startup.

/* Take input, make quick assessment of items which break the process */
PROCEDURE startup:
    MESSAGE "Calculate a Fibonacci number. Enter Fibonacci number to calculate" UPDATE ioutput.
    IF ioutput = 1 OR ioutput = 2 THEN ASSIGN ifib3 = 1.
    IF ioutput = 0 THEN ifib3 = 0.
    RUN calculate.
    END PROCEDURE.
    
    
/* Calculate fibonacci based on currently know values to create a 3rd, then roll the numbers down to restart the process */
PROCEDURE calculate: 
    DO WHILE icount <= ioutput:
        ifib3 = ifib2 + ifib1.
        ifib1 = ifib2.
        ifib2 = ifib3. 
        icount = icount + 1.
    END.
    RUN OUTPUT.
END PROCEDURE.

/* Visual output */
PROCEDURE OUTPUT:  
    MESSAGE "Fibonacci number" ioutput "is equal to" ifib3.
    ASSIGN ifib1 = 1 ifib2 = 1 ifib3 = 1.
    RUN rerun.
END PROCEDURE.

/* Choose to re-run the program */
PROCEDURE rerun.   
    MESSAGE "Run Again?" UPDATE again.
    IF again = TRUE THEN RUN startup.
    END PROCEDURE.










