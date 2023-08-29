DEF VAR iInput as INteger NO-UNDO.
DEF VAR iCheck as logical.
DEF VAR iCount as INTEGER INIT 0.
DEF VAR iUpdate as logical init NO.

Run MENU.

Procedure MENU:
Run Update.
Run DebINV.
Run DebTRAN.
END.

Procedure Update.
MESSAGE "Update?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO SET iUpdate.
END.

Procedure DebINV:
OUTPUT TO VALUE ("e:\temp\DebINV.csv").
FOR EACH debinv WHERE
    debinv.category2 matches "CONF" AND
    debinv.category1 <> "" AND
    debinv.due < date(debinv.category1) 
    exclusive:
EXPORT DELIMITER "," debinv.invoice debinv.due debinv.category1.
        iCount = iCount +  1.
        IF iUpdate = YES THEN
        update debinv.due = date(debinv.category1).
     END.
END.

Procedure DebTRAN:
OUTPUT TO VALUE ("e:\temp\DebTRAN.csv").
FOR EACH debinv WHERE
    debinv.category2 matches "CONF" AND
    debinv.category1 <> "":
        for each sorder of debinv:
            for each debtran of sorder where 
                debtran.invoice = debinv.invoice AND 
                debinv.due <> debtran.due AND 
                debtran.due <> ? exclusive:
                EXPORT DELIMITER "," debtran.invoice debtran.due debinv.due.
		IF iUpdate = YES THEN
                update debtran.due = debinv.due.
              END.
        END.
     END.
  MESSAGE iCount "items found" VIEW-AS ALERT-BOX.
END.
