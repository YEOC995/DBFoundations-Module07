#About Functions
----------------
By: Carolyn Yeo

##Introduction
---------------
Functions in SQL have various purposes that are useful to the every-day programmer. 
They can return values or tables. This paper will focus on user defined functions and the different types they can be.

##When to Use UDF:
UDF’s have advantages when used in a database. To name a few, they can be stored in the database and called upon any number of times, allow for faster execution, and can be used for complex code that can’t be expressed in a single scalar expression (https://docs.microsoft.com/en-us/sql/relational-databases/user-defined-functions/user-defined-functions?view=sql-server-ver15, External Site, 2020). Knowing this, there are three types of functions that will be focused on that will be useful when creating a UDF – scalar, inline, and multi-statement functions.

##Different Functions:
----------------------
###Scalar Functions:
--------------------
Scalar functions will return only a single value. This function can be stored in the database so it won’t have to be written out each time (https://www.sqlservertutorial.net/sql-server-user-defined-functions/sql-server-scalar-functions/, External Site, 2020). 

###Inline Functions:
--------------------
Inline functions, unlike scalar, do not return a single value. Instead, a table is returned based on the select statement and what parameter you are filtering for inside the select statement. This function is also called an inline table-valued function (ITVF) (https://www.red-gate.com/simple-talk/sql/t-sql-programming/sql-server-user-defined-functions/, Phil Factor, External Site, 2020).

###Multi-Statement Functions:
-------------------------------
A multi-statement table-valued function (MSTVF) is also another table-valued function that can return the results of multiple statements. This allows you to execute multiple queries within and aggregate them into one table (https://www.sqlservertutorial.net/sql-server-user-defined-functions/sql-server-table-valued-functions/#:~:text=A%20multi%2Dstatement%20table%2Dvalued,results%20into%20the%20returned%20table., External Site, 2020).

##Summary:
----------
To summarize, user defined functions have a wide range of use in any database. It is important to know when it is appropriate to use and the type of result you are looking for – a single value, or a table. This should give you enough information to get started and understand the range of uses user defined functions have in databases.
