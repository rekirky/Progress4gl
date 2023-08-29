DEF VAR iemail LIKE debtor.email FORMAT "x(50)".
DEF VAR iedit AS LOG INIT NO.
DEF VAR i AS IN NO-UNDO.

MESSAGE "Enter Email" SET iemail.

DEF TEMP-TABLE t NO-UNDO
    FIELD tacc LIKE debtor.deb_acc
    FIELD tname LIKE debtor.name
    FIELD tcontact LIKE debcontact.contact_type FORMAT "x(50)"
    FIELD ttype AS CHAR FORMAT "x(10)"
    FIELD temail LIKE debtor.email FORMAT "x(50)".

CURRENT-WINDOW:WIDTH = 200.

FOR EACH debtor WHERE debtor.email matches "*" + iemail + "*":
    CREATE t.
    ASSIGN
        tacc = debtor.deb_acc
        tname = debtor.name
        tcontact = "Main Contact"
        ttype = "Debtor"
        temail = debtor.email.
END.

FOR EACH debcontact WHERE debcontact.email matches "*" + iemail + "*":
    FIND FIRST debtor OF debcontact.
    FIND FIRST conttype OF debcontact.
    CREATE t.
    ASSIGN
        tacc = debtor.deb_acc
        tname = debtor.name
        tcontact = conttype.description
        ttype = "Debtor"
        temail = debcontact.email.
END.

FOR EACH creditor WHERE creditor.email matches "*" + iemail + "*":
    CREATE t.
    ASSIGN
        tacc = creditor.cred_acc
        tname = creditor.name
        tcontact = "Main Contact"
        ttype = "Creditor"
        temail = creditor.email.
END.

FOR EACH credcontact WHERE credcontact.email matches "*" + iemail + "*":
    FIND FIRST creditor OF credcontact.
    FIND FIRST conttype OF credcontact.
    CREATE t.
    ASSIGN
        tacc = creditor.cred_acc
        tname = creditor.name
        tcontact = conttype.description
        ttype = "Creditor"
        temail = credcontact.email.
END.

FOR EACH t:
i = i + 1.
END.

MESSAGE i " records found. Do you wish to edit?" VIEW-AS ALERT-BOX BUTTONS YES-NO UPDATE iedit.

FOR EACH t EXCLUSIVE:
IF iedit = no THEN
    DISPLAY t
    WITH WIDTH 200.
    ELSE
    UPDATE t.
END.
