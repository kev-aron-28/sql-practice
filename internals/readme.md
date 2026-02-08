# How does POSTGRESQL work?

SHOW data_directory - This show where the current POSTGRESQL installation is located

All the data of the database you have installed are located inside the
/base folder

In there you will see multiple folders with different numbers or ids, to know what they mean

``` sql
select oid, datname from pg_database;
```

So when you enter the spcefic folder that matches your database then you will see a lot of different files with numbers
that is the current data you are storing

To check what each of this files mean

``` sql
select * from pg_class;
```

# Terminology

- Heap or heap file: File that contains all the data (rows) of our table
- Tuple or item: Individual row from the table
- Block or page: The heap file is divided into many different blocks or pages. Each
Store some number of rows

HEap file 
 ---------------------------------------------------
 |   ___________________________________________   |
 |   |                                           | |
 |   |   BLock or a page                         | |
 |   |   |_ THis contains the rows or items      | |
 |   |___________________________________________| |
 |                                                 |
 |                                                 |
 |                                                 |
 |                                                 |
 |                                                 |
 --------------------------------------------------

Each block is 8kb large

So each block inside a heap file contains pieces of bytes indicating different information
- Information about the block
- Information about how to locate each item inside that block
- Data of rows or touples

# Overall page layout
- Each page is 8kb
- PageHeaderData: 24 bytes long and contains general information about the page, including free space points.
- ItemIdData: Array of item identifiers pointing to the actual items.  Each is (offset, length) pair. 4 bytes per item
- Free space: Unallocated fspace
- Items: The actual items themselve
- Special space: index access method specific data. Different methods store different data. Empty in ordinary tables


## PAge header layout
pd_lsn	PageXLogRecPtr	8 bytes	LSN: next byte after last byte of WAL record for last change to this page
pd_checksum	uint16	2 bytes	Page checksum
pd_flags	uint16	2 bytes	Flag bits
pd_lower	LocationIndex	2 bytes	Offset to start of free space
pd_upper	LocationIndex	2 bytes	Offset to end of free space
pd_special	LocationIndex	2 bytes	Offset to start of special space
pd_pagesize_version	uint16	2 bytes	Page size and layout version number information
pd_prune_xid	TransactionId	4 bytes	Oldest unpruned XMAX on page, or zero if none