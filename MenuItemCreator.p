/*Usage - takes a csv of program name & description, prompts the user for a folder name and then creates a folder & sub-objects.*/


DEF VAR filename AS CHARACTER NO-UNDO.
DEF VAR cMenuName AS CHAR NO-UNDO.
DEF VAR menu LIKE menusys.menu_obj.
DEF VAR order LIKE menusys.MENU_order.

DEFINE TEMP-TABLE ttProgram
    FIELD ttProgName AS CHAR
    FIELD ttDesc AS CHAR.

PAUSE 0 BEFORE-HIDE.
    MESSAGE "Enter Customer Code" SET cMenuName.
    FIND FIRST menusys WHERE menusys.MENU_label = cMenuName EXCLUSIVE NO-ERROR.
        IF AVAIL menusys THEN
        ASSIGN MENU = menusys.menu_obj.
        IF NOT AVAIL menusys THEN DO:
            RUN folderorder.
            CREATE menusys.
                ASSIGN  menusys.MENU_label = cMenuName
                        menusys.menu_type = "Folder"
                        menusys.menu_order = order.
                ASSIGN MENU = menusys.menu_obj.
               END.

DEFINE STREAM strImport.

SYSTEM-DIALOG GET-FILE filename
TITLE "Choose file to load"
FILTERS "Comma Seperated Values (*.csv)" "*.csv"
MUST-EXIST
USE-FILENAME.

INPUT STREAM strImport FROM VALUE (filename).
REPEAT:
    CREATE ttProgram.
    IMPORT STREAM strImport DELIMITER "," ttProgram.
    END.
    INPUT CLOSE.
    
    FOR EACH ttProgram:
        DISPLAY ttProgram.
        IF CAN-FIND(FIRST menusys WHERE menusys.prog_id = ttProgram.ttProgName AND PARENT_obj = MENU) THEN NEXT.
          RUN menuorder.
          CREATE menusys.
                  ASSIGN menusys.menu_label = ttProgram.ttDesc
                   menusys.PARENT_obj = MENU
                   menusys.MENU_type = 'program'
                   menusys.prog_id = ttProgram.ttProgName
                   menusys.MENU_order = order.
        END.

PROCEDURE folderorder.
    order = 0.
    FOR EACH menusys WHERE MENU_type = "folder":
        IF menusys.MENU_order > order THEN
            ASSIGN order = menusys.MENU_order.
    END.
    order = order + 1.
    END PROCEDURE.

PROCEDURE menuorder.
    order = 0.
    FOR EACH menusys  WHERE menusys.MENU_type = "program":
        IF menusys.MENU_order > order THEN
            ASSIGN order = menusys.MENU_order.
    END.
    order = order + 1.
    END PROCEDURE.  

