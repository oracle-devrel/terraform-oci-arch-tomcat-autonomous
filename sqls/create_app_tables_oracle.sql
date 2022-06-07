CREATE TABLE TODOS (
id number GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1), 
title varchar2(255),
description varchar2(255),
is_done char(1) check (is_done in ('Y','N')) 
);
SELECT * FROM TODOS;
exit;
