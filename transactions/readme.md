What are transaction used for?
TO have atomic operations where you can kind of redo all the operations that 
you first try to made


# How to
SO the DB creates a separate connection from the main data pool

BEGIN;

UPDATE ACCOUNTS
set balance 


Run Rollback to dump all pending changes and delete the separate workspace
Running a bad command will put the transaction in an aborted state- you must roll back

You must commit your changes with COMMIT 

