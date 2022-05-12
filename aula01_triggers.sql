create database funcionarios_db;

create table setores
(
	id int auto_increment primary key,
    nome varchar(50) not null,
    total_salario decimal(12,2) default 0
);

insert into setores (nome)
	values('Desenvolvimento'),('Suporte'),('Adminstrativo'),('Gestão');
    
create table funcionarios
(
	id int auto_increment primary key,
    nome varchar(70) not null,
    salario decimal(12,2) default 0,
    id_setor int not null,
    constraint setor_has_funcionarios_fk
		foreign key(id_setor) 
			references setores(id)
				on update cascade
                on delete restrict 
);
drop trigger if exists trigger_salario_setor;
DELIMITER $$
CREATE TRIGGER trigger_salario_setor AFTER INSERT ON funcionarios
	FOR EACH ROW
BEGIN
	
	update setores set total_salario = total_salario + NEW.salario
    where id = NEW.id_setor;
    
END $$
DELIMITER ;

select * from setores ;
select * from funcionarios ;
delete from funcionarios where id=1;

insert into funcionarios (nome, salario,id_setor)
	values('Rafael', '12900',1);
insert into funcionarios (nome, salario,id_setor)
	values('Joao da silva', '2950',1);
insert into funcionarios (nome, salario,id_setor)
	values('alice nascimento', '7500',3);
    
   
    /*
    tabelas temporárias
    NEW = guarda a tupla que está sendo inserida no momento da execução da trigger
    OLD = guarda a tupla que está sendo deletada no momento da execução da trigger
    */

drop trigger if exists trigger_update_sal_after_delete;
DELIMITER $$
CREATE TRIGGER trigger_update_sal_after_delete AFTER DELETE ON funcionarios
	FOR EACH ROW
BEGIN	
	update setores set total_salario = total_salario - OLD.salario
    where id = OLD.id_setor;    
END $$
DELIMITER ;


-- update 

drop trigger if exists trigger_update_sal_after_update;
DELIMITER $$
CREATE TRIGGER trigger_update_sal_after_update AFTER UPDATE ON funcionarios
	FOR EACH ROW
BEGIN	
	DECLARE tipo varchar(30);
    
	update setores set total_salario = 
		total_salario + (NEW.salario - OLD.salario)
    where id = NEW.id_setor;   
    -- só adicionar o log e teve redução ou aumento de salário.
    IF(NEW.SALARIO <> OLD.salario) THEN
		IF(NEW.salario > OLD.salario) THEN
			SET tipo = ' aumentou ';
        ELSE
			SET tipo = ' reduziu ';
        END IF;
        
		insert into logs2 (message,data_log) 
			values(concat('Salário do ', 
						   NEW.nome,
                           tipo,
						 'para R$ ',
						 NEW.salario), current_timestamp);
	END IF;
END $$
DELIMITER ;

 select * from setores ;
select * from funcionarios ;
update funcionarios set salario = 10000
where id = 6;
select * from logs2;
-- criar um log para guardar as atualizações de salários
create table logs2
(
	id int auto_increment primary key, 
    message varchar(2000) not null
);
alter table logs2 add column data_log timestamp;


select current_timestamp