/* G016939 - POP */
/* Analyse and invoices to see if they are finalised. Match up diary entries and look for variances between invoice date & diary date.*/
/* Export findings to CSV */

output to value ("c:\temp\diaryexport.csv").
def var icheck as log init false.
def var ikey like diary.key_id.
for each debinv where finalised by debinv.invoice:
    if avail debinv then do: 
        find first debtor of debinv.
            assign ikey = debinv.ent_code_sale + "," + string(debinv.invoice).
    end.
    find first diary where diary.key_id = ikey and diary.table_id = "debinv" no-error.
    if avail diary then do:
        if debinv.tran_date <> diary.diary_date then do:
            assign icheck = TRUE.
            end.
        export delimiter ","
        debinv.invoice
        debinv.ent_code_sale
        string(debinv.user_id) label "Invoice User ID"
        debtor.deb_acc
        debinv.inv_total
        debinv.enter_date label "Enter Date"
        string(debinv.enter_time,"HH:MM:SS") label "Enter Time"
        debinv.tran_date label "Invoice Date"
        string(debinv.tran_time,"HH:MM:SS") label "Invoice Time"
        diary.user_id label "Diary User ID"
        diary.diary_date label "Diary Date"
        string(diary.diary_time,"HH:MM:SS") label "Diary Time"
        icheck.
        end.
end.
