
/* Cycle 1 */

for each debtor
where debtor.category1 = 'eml'
or debtor.category1 = 'emlnoinv':
or debtor.category1 = "emlinv"
or debtor.invoice-method = "e" and debtor.category1 = ""
display debtor.deb-accn debtor.invoice-method debtor.sorder-category debtor.category1


/*
    update debtor.sorder-category = "Del"
    update debtor.invoice-method = "pe"
*/


/* Cycle 2 */

for each debtor
where debtor.category1 = "emlinv":
display debtor.deb-accn debtor.invoice-method debtor.sorder-category debtor.category1

/*  
    update debtor.sorder-category = "INV"
    update debtor.invoice-method = "pe"
*/


/* Cycle 3 */

for each debtor
where debtor.invoice-method = "e"
and debtor.category1 = "":
display debtor.deb-accn debtor.invoice-method debtor.sorder-category debtor.category1

/* 
    update debtor.sorder-cateogyr = "Del"
    update debtor.invoice-method = "pe"
*/

/* Cycle 4 */

for each debtor
where debtor.invoice-method = "p"
and debtor.category1 = "":
display debtor.deb-accn debtor.invoice-method debtor.sorder-category debtor.category1

/*
    update debtor.sorder-category = "INV"
    update debtor.invoice-method = "p"
*/

/* Cycle 5 - Only run on SAMIOS */

for each debtor
where bebtor.sorder-category1 <> "SHO"



