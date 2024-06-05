/*
  © Shadow-2000 > 15.02.2024
  This functions reads a given IFS-File.

  TODOS: 
  > End lines with the newline and end-of-line characters.
*/

CREATE OR REPLACE FUNCTION shadow2000.read_file_from_ifs(File_ VarChar(256)) RETURNS CLOB ccsid 1208
BEGIN ATOMIC
  DECLARE File_content CLOB ccsid 1208;
  SELECT
    LISTAGG(IFNULL(Line, ' ') concat ' ')
  INTO
    file_content
  FROM
    TABLE(QSYS2.IFS_READ_UTF8(PATH_NAME => TRIM(File_);
    
  Return file_content;
END;

-- test
select shadow2000.read_file_from_ifs('/home/shadow2000/tst.txt') from SYSIBM.SYSDUMMY1;
