Copy .p programs to /prg folder (Server & Client - there may be multiple clients)

Run script below:
Change the following

cProgName = the program being deployed
program.description = the name to be displayed in the menu
program.module = the module to be used (refer list below)
menulocal.menu-key = the menu key to be used (refer list below) NOTE: this is needed 3 times





def var cProgName as char no-undo.
def var iMenuOrder as int init 1 no-undo.

cProgName = 'cnwinvimp.p'.

if not can-find(first program where program.prog-name = cProgName) then

do transaction on error undo, return:
    create program.
    assign program.prog-name = cProgName
        program.description = 'Inventory Import'
        program.module = 'iv'
        program.on-menu = YES
        program.disp-type = ''
        program.module-sub = ''.db
end.

if not can-find(menulocal where menulocal.menu-key = "invop"
                and menulocal.prog-name-run = cProgName) then 
do transaction on error undo, return:
    find last menulocal where menulocal.menu-key = "invop" no-error.
    if avail menulocal then 
        iMenuOrder = menulocal.menu-order + 1.        
    create menulocal.
    assign menulocal.menu-key = "invop"
        menulocal.menu-order = iMenuOrder
        menulocal.menu-handle = ""
        menulocal.prog-name-run = cProgName.
end.

/* find item
find first program where program.description = 'Bulk Update Reorder Detail' no-error.
find first menulocal where menulocal.prog-name-run = program.prog-name no-error.
display menulocal.menu-key.
*/
/*
aa Admin
ac Config 
ba banking
cr Acc Pay
	credop
	credrep
db Acc Rec 
	dbexp
	dbrep
	debexp
	debop
	debrep
ed B2B
gl General Ledger
	glrep
iv inventory
	invexp
	invop
	invrep
	ivexp
	ivrep
jc production 
ma marketing
oe sales
	oeexp
	oerep
po purchasing
	poexp
	porep
pr pricing
	prexp
	priexp
	priop
sh importing
	shop
	shrep
sv service
	svexp
	svordexp
wh warehouse
	warerep
	whrep
*/



/* Test new file with input boxes */

DEF VAR cProgName AS CHAR NO-UNDO.
DEF VAR cMenuName AS CHAR NO-UNDO.
DEF VAR cMenuKey AS CHAR NO-UNDO.
DEF VAR cModule AS CHAR NO-UNDO.
def var iMenuOrder as int init 1 no-undo.

MESSAGE 'Enter Program Name (*.p):' SET cProgName.
MESSAGE 'Enter Title For Menu: ' SET cMenuName.
MESSAGE 'Enter Module: ' SET cModule.
MESSAGE 'Enter Menu Key: ' SET cMenuKey.
 

MESSAGE 'Program: 'cProgName skip 'Module: ' cModule skip 'Menu Key: ' CMenuKey skip 'Continue?'
    VIEW-AS ALERT-BOX INFO BUTTONS OK-CANCEL.


if not can-find(first program where program.prog-name = cProgName) then

do transaction on error undo, return:
    create program.
    assign program.prog-name = cProgName
        program.description = cMenuName
        program.module = cModule
        program.on-menu = YES
        program.disp-type = ''
        program.module-sub = ''.
end.

if not can-find(menulocal where menulocal.menu-key = cMenuKey
                and menulocal.prog-name-run = cProgName) then 
do transaction on error undo, return:
    find last menulocal where menulocal.menu-key = cMenuKey no-error.
    if avail menulocal then 
        iMenuOrder = menulocal.menu-order + 1.        
    create menulocal.
    assign menulocal.menu-key = cMenuKey
        menulocal.menu-order = iMenuOrder
        menulocal.menu-handle = ""
        menulocal.prog-name-run = cProgName.
end.
