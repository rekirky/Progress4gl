
/*------------------------------------------------------------------------
    File        :   BURdeldebattrib.p

    Description :   Deletes debtor's attributes from an import list.

    Author(s)   :   Nigel.Allen
    
    Created     :   Wed Jan 03 09:40:45 EST 2018
    
    Notes       :   This program expects a text file as input. The file will contain only 
                    a list of debtor's codes. Any debtor that appears on this list will have 
                    all of it's debattrib records deleted so that Burson can recreate them as there
                    is currently no way to delete debattrib records (only to update them).
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

def stream sImport.
def var wDebAccn as char no-undo.
def var iDebAccn like debtor.deb-accn.
def var iInCnt as int no-undo.
def var iDelCnt as int no-undo.

def var inputfile as char initial "c:\users\nigel.allen\delattrib.csv".               /* Your File Goes Here */

/* ***************************  Main Block  *************************** */

message
    "This program will delete all debtor's attributes" skip
    "for debtors that appear in your input file" skip(1)
    "Press <OK> when ready to start or <Cancel> to escape"
    view-as alert-box
    buttons ok-cancel
    update lOkay as log.
    
if not lOkay then 
    return.

if search(inputfile) = ? then
do:
    message 
        "Cannot find your input file" inputfile
        view-as alert-box.
    return.
end.

input stream sImport from value(inputfile).

R1:
repeat:
    import stream sImport
        wDebAccn.
    iInCnt = iInCnt + 1.
    iDebAccn = int(wDebAccn) no-error.
    if error-status:error then
        next R1.
    repeat transaction:
        find next debattrib 
            where debattrib.deb-accn = iDebAccn
            and debattrib.attrib-set < 3
            exclusive-lock no-error.
        if not available debattrib then
            next R1. 
        delete debattrib.
        iDelCnt = iDelCnt + 1.
    end.
end.

input stream sImport close.

message 
    "Deletion Complete" skip (1)
    "Debtors Processed:" iInCnt skip
    "Attributes Deleted:" iDelCnt
    view-as alert-box.
    
return.
