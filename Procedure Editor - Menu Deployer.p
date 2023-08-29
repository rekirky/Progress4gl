DEF VAR iInput AS INT NO-UNDO.
DEF VAR iChecker AS LOG INIT TRUE NO-UNDO.
DEF VAR iVer AS CHAR NO-UNDO INIT "0".


RUN verchecker.
RUN menu.


PROCEDURE menu:
    set iInput = 0.
    MESSAGE 
        "Select Program To Run: (1.) Deploy (2.) Delete" SET iInput.
    IF iVer = "5" AND iInput = 2 THEN DO:
        RUN 24del.
    END.
    IF iVer = "5" AND iInput = 1 THEN DO:
        RUN 24add.
    END.
    IF iVer = "7" AND iInput = 2 THEN DO:
        RUN 31del.
    END.
    IF iVer = "7" AND iInput = 1 THEN DO:
        RUN 31add.
    END.

RUN rerun.
END PROCEDURE.

PROCEDURE verchecker:
    FIND FIRST syconfig.
    SET iVer = substring(syconfig.version,1,1).
END PROCEDURE.


PROCEDURE 24del:
    DEF VAR cProgram AS CHAR NO-UNDO FORMAT "x(30)" INIT "Enter".
    DEF VAR cCount AS INTEGER NO-UNDO INIT 0.
    
    MESSAGE "V2.4 Menu Item Removal Process".
    IF iChecker = TRUE THEN DO:
        MESSAGE "Enter program name to remove" SET cProgram.
        FOR EACH program WHERE program.description matches "*" + cProgram + "*" EXCLUSIVE-LOCK:
            ASSIGN cCount = cCount + 1.
            IF cCount > 0 THEN DO:
                DISPLAY prog-name description module.
                MESSAGE "Do you want to delete this record?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO SET iChecker.
                IF iChecker = TRUE THEN DO:
                    DELETE program.
                    MESSAGE "Program Deleted".
                END.
            END.
        END.
        IF cCount = 0 THEN DO:
            MESSAGE "No Results Found" VIEW-AS ALERT-BOX WARNING.
        END.
    END.
END PROCEDURE.

PROCEDURE rerun:
    MESSAGE "Run again?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO SET iChecker.
        IF iChecker = TRUE THEN DO:
            RUN menu.
        END.
END PROCEDURE.

PROCEDURE 24add:
DEF VAR cProgName AS CHAR NO-UNDO FORMAT "x(20)".
DEF VAR cProgDesc AS CHAR NO-UNDO FORMAT "x(30)" init "TEST".
DEF VAR cModule AS CHAR INIT "IV" NO-UNDO.
DEF VAR cSub AS CHAR NO-UNDO INIT "INVOP".
DEF VAR iMenuOrder AS INT NO-UNDO INIT 1.

MESSAGE "V2.4 Menu Item Deployment Process" SKIP
        'If left blank - description will be "TEST", Module will be "IV", Sub-menu will be "INVOP' VIEW-AS ALERT-BOX.

IF iChecker = TRUE THEN DO:
    MESSAGE 'Enter Program Name' SET cProgName.
    MESSAGE 'Enter Displayed Menu Description' SET cProgDesc.
    set iChecker = FALSE.
    MESSAGE 'Do you require a list of modules?' VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO set iChecker.
    IF iChecker = TRUE THEN DO:
        FOR EACH SYSMODUL: 
            display module description.
        END.
        set iChecker = FALSE.
    END.
    MESSAGE 'Enter Module' SET cModule.
    set iChecker = FALSE.
    MESSAGE 'Do you need a list of sub-menus?' VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO set iChecker.
    IF iChecker = TRUE THEN DO:
        Message 
        "cr Acc Pay: credop / credrep" SKIP
        "db Acc Rec: dbexp / dbrep / debexp / debop / debrep" SKIP
        "gl General Ledger: glrep" SKIP
        "iv inventory: invexp / invop / invrep / ivexp / ivrep" SKIP
        "oe sales: oeexp / oerep" SKIP
        "po purchasing: poexp / porep" SKIP
        "pr pricing: prexp / priexp / priop" SKIP
        "sh importing: shop / shrep"
        "sv service: svexp / svordexp" SKIP
        "wh warehouse: warerep / whrep".
        set iChecker = FALSE.
    END.
    MESSAGE "Enter sub-menu" SET cSub.
    IF NOT CAN-FIND(FIRST program WHERE program.prog-name = cProgName) THEN DO
        TRANSACTION ON ERROR UNDO, RETURN:
            CREATE program.
                ASSIGN  program.prog-name = cProgName
                        program.description = cProgDesc
                        program.module = cModule
                        program.on-menu = YES
                        program.disp-type = ''
                        program.module-sub = ''.
            END.
            IF NOT CAN-FIND(menulocal WHERE menulocal.menu-key = cSub
            AND menulocal.prog-name-run = cProgName) THEN DO 
                TRANSACTION ON ERROR UNDO, RETURN:
                    FIND LAST menulocal WHERE menulocal.menu-key = cSub NO-ERROR.
                    IF AVAIL menulocal THEN
                        iMenuOrder = menulocal.menu-order + 1.        
                        CREATE menulocal.
                        ASSIGN 
                            menulocal.menu-key = cSub
                            menulocal.menu-order = iMenuOrder
                            menulocal.menu-handle = ""
                            menulocal.prog-name-run = cProgName.
                    END.
                    MESSAGE "Process Completed:" cProgName "deployed to" cModule "/" cSub "with name" cProgDesc "." VIEW-AS ALERT-BOX.
            END.
END PROCEDURE.
