/*
  © Shadow-2000 > 05.06.2024
  Simple function to split a string by a given delimiter.

  A simple function to split a string into words at a given delimiter. IBM already provides a function called systools.split(). However, this function may have problems correctly formatting utf-8 strings with some special characters (for example, ‘ä’).
  Example i've testet on: select * from TABLE(systools.split(CAST('stärker, schneller, besser' as varchar(32000) ccsid 1208), ' '));

  TODOS:
  > The delimiter should be able to accommodate more than one character.
*/
CREATE OR REPLACE FUNCTION shadow2000.split_string_at_delimiter(string_in varchar(32000), delimiter char(1)) returns TABLE(row_id integer, word Varchar(32000))
 BEGIN 
   return
     with returnwording (current_word, beginn, ende, word) as (
      Select 
        1 as current_word,
        1 as beginn, 
        locate(delimiter, string_in) as Ende,
        SUBSTRING(string_in, 1, locate(delimiter, string_in)) as word
      from 
        table(values string_in) as a(word)
      union all select
        current_word + 1 as current_word,
        ende + 1 as beginn,
        locate(delimiter, string_in, ende + 1) as Ende,
        CASE
          when (locate(delimiter, string_in, ende + 1) > 0) then SUBSTRING(string_in, ende + 1, locate(delimiter, string_in, ende + 1) - ende - 1)
          else SUBSTRING(string_in, ende + 1)
        end as word
      from 
        returnwording, 
        table(values string_in) as b(word)
      where 
        ende > 0
    )
    Select current_word, word
    from returnwording
    order by current_word;
 END;


select CAST(word as Varchar(32000) ccsid 1208) from TABLE(shadow2000.split_string_at_delimiter('Wort_1 Wort_2 Wort_3', ' '));
