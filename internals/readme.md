# Where does postgres store data?

show data_directory;

To show where data is being stored

Heap or Heap file: File that contains all the data of our table

Tuple or item: Individual row from table

Block or page: The heap file is divided into many different blocks of pages
Each page stores some number of rows


# BLock data layout