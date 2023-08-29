RUN comobj/StartSuper.p ('comobj/propertyMan.p', SESSION).		/* Special Stuff to allow update */
RUN comobj/StartSuper.p ("comobj/admService.p", SESSION).


FIND FIRST product WHERE prod_code = "ZZZZZZ" EXCLUSIVE.		/* EXCLUSIVE needed to lock file to your process */
UPDATE product.deposit product.description.				/* Allows you to update these fields as manual process */

ASSIGN product.deposit = no product.description = "Test1"		/* Allows you to update these fields automatically (Careful) */


*Bulk update example (Remove deposit items)
FOR EACH product WHERE product.deposit = YES EXCLUSIVE:
ASSIGN product.deposit = no.


*Bulk update example (manually set a description)
FOR EACH product WHERE product.description = "" EXCLUSIVE:
DISPLAY product.prod_code.
UPDATE product.description.