--과제
---정규표현식 전화번호
select phone_number from employees where regexp_like (phone_number, '([[:digit:]]{3})\.([[:digit:]]{3})\.([[:digit:]]{4})');

