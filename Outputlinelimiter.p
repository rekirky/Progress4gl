RUN outputlimiter.

PROCEDURE outputlimiter.
DEF VAR num      AS INT INIT 1.
DEF VAR counter AS INT INIT 1.
DEF VAR limit   LIKE counter INIT 10000.                                     /* Number of lines per file */
MESSAGE "Enter lines per file - default 1000" UPDATE limit.       /* Optional extra, front end to define output limit */
        
    FOR EACH product:    
        IF counter = limit THEN   
            ASSIGN  num = num + 1
                    counter = 1.
        OUTPUT TO VALUE ("c:\temp\Output - " + STRING(limit) + " lines - file # - " + STRING(num) + ".csv") APPEND. /*output file name */
                EXPORT DELIMITER "," product.
                ASSIGN counter = counter + 1.
        OUTPUT CLOSE.
   END.
END PROCEDURE.
  
