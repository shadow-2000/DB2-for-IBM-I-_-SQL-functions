/*
  © Shadow-2000 > 11.03.2024
  A simple function to read a selected column from a CSV-formatted string.

  TODOS: 
  > change the input variable to DBCLOB
*/

CREATE OR REPLACE FUNCTION shadow2000.get_column_from_csv_string(csv_string VARCHAR(32000), column_number int) RETURNS VARCHAR(1024)
BEGIN ATOMIC
  DECLARE column_value VARCHAR(1024);
  SET column_value = TRIM(REGEXP_SUBSTR(TRIM(REGEXP_SUBSTR(csv_string, '((;)?[^;]*){' concat TRIM(char(column_number)) concat '}')), '([^;]*)$'));
  Return column_value;
END;

-- Usage:
select shadow2000.get_column_from_csv_string(csv_string, 1),
       shadow2000.get_column_from_csv_string(csv_string, 2)
FROM TABLE(VALUES('A;B;C')) as X(csv_string);
