/* V3 - transaction type finder */
/* Helps locate a file for both debtor & creditor for all transaction types */

DEF VAR idoc LIKE debtran.dtran_type.
DEF VAR ideb LIKE debtor.deb_acc.
DEF VAR icred LIKE creditor.cred_acc.
DEF VAR idesc LIKE dbtrantyp.description.
DEF VAR idnum LIKE debtran.invoice COLUMN-LABEL "Doc #".
DEF VAR icnum LIKE credtran.invoice COLUMN-LABEL "Doc #".
DEF VAR iout AS LOG INIT yes.

MESSAGE "Include data dump to c:\temp?" update iout.

    FOR EACH dbtrantyp:
        ASSIGN idoc = dbtrantyp.dtran_type.
        ASSIGN idesc = dbtrantyp.description.
        RUN dtran.
        CURRENT-WINDOW:WIDTH=200.
        DISPLAY idesc idoc ideb idnum icred icnum
        WITH WIDTH 200.
        IF iout = TRUE THEN DO:
        OUTPUT TO VALUE ("c:\temp\docoutput.csv") append.
        EXPORT DELIMITER "," idesc idoc ideb idnum icred icnum.
        END.
        OUTPUT CLOSE.
        END.

PROCEDURE dtran:
FIND FIRST debtran WHERE dtran_type = idoc AND finalised = yes no-error.
    IF AVAIL debtran THEN DO:
        FIND FIRST debtor OF debtran NO-ERROR.
        ASSIGN ideb = debtor.deb_acc.
        ASSIGN idnum = debtran.invoice.
    END.
RUN ctran.
END PROCEDURE.

PROCEDURE ctran:
FIND FIRST credtran WHERE ctran_type = idoc NO-ERROR.
    IF AVAIL credtran THEN DO:
        FIND FIRST creditor OF credtran NO-ERROR.
        ASSIGN icred = creditor.cred_acc.
        ASSIGN icnum = credtran.invoice.
    END. 
END PROCEDURE.



