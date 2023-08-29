def var cProgName as char no-undo.
def var iMenuOrder as int init 1 no-undo.

cProgName = 'burdebattimp.p'.

if not can-find(first program where program.prog-name = cProgName) then

do transaction on error undo, return:
    create program.
    assign program.prog-name = cProgName
        program.description = 'Customer Attribute Import'
        program.module = 'db'
        program.on-menu = YES
        program.disp-type = ''
        program.module-sub = ''.
end.

if not can-find(menulocal where menulocal.menu-key = "dbexp"
                and menulocal.prog-name-run = cProgName) then 
do transaction on error undo, return:
    find last menulocal where menulocal.menu-key = "dbexp" no-error.
    if avail menulocal then 
        iMenuOrder = menulocal.menu-order + 1.        
    create menulocal.
    assign menulocal.menu-key = "dbexp"
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
