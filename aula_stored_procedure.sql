delimiter //
CREATE PROCEDURE livros_t_count (IN editora int)
       BEGIN
         SELECT COUNT(*) as numero FROM livros
         WHERE editora_id = editora;
       END//
delimiter ;

CALL livros_t_count(2);

create table tabuada(result varchar(100));
select * from tabuada;

drop procedure if exists tab;

delimiter $$
CREATE PROCEDURE tab (pTabuadaDo int)
BEGIN
 DECLARE i int default 1;
 DECLARE r int default 0;
 DECLARE msg varchar(100);
	
    delete from tabuada;
	while i<=10 do
		set r = i * pTabuadaDo;
        set msg = concat(pTabuadaDo,' x ', i, ' = ', r);
        insert into tabuada(result) values(msg);
        set i=i+1;
    end while;
    
    select * from tabuada;
 
END$$
delimiter ;
-- teste de mesa
i	r
1	5
2	10
3	15

SET SQL_SAFE_UPDATES = 0;
call tab(6);

5*1=5
5*2=10

-- vamos refatorar pra verificar se já tem a tabuada de um número pra não inserir novamente
alter table tabuada add column num int;
drop procedure if exists tab2;
delimiter $$
CREATE PROCEDURE tab2 (pTabuadaDo int)
BEGIN
 DECLARE i int default 1;
 DECLARE r int default 0;
 DECLARE msg varchar(100);
 
    if((select count(num) from tabuada where num=pTabuadaDo)=0) THEN
    
		while i<=10 do
				set r = i * pTabuadaDo;
				set msg = concat(pTabuadaDo,' x ', i, ' = ', r);
				insert into tabuada(num,result) values(pTabuadaDo,msg);
				set i=i+1;
		end while;
        
	end if;
    select * from tabuada where num = pTabuadaDo;
 
END$$
delimiter ;

call tab2 (5);