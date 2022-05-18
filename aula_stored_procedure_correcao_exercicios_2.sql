/*
Crie uma tabela Pessoas que contenha as colunas id, nome, sexo e data_nascimento.
1 - Crie uma Store Procedure onde sejam possíveis passar como parâmetro as informações para
	Nome, Sexo e Data_Nascimento. Esta Stored Procedure deverá consultar no banco de dados o último ID gerado na tabela de Pessoas,
    incrementar este ID e inserir um registro nesta tabela com os dados enviados por parâmetro.

*/

create table pessoas 
(
	id int not null primary key,
    nome varchar(100),
    sexo char(1),
    data_nascimento date
);


drop procedure if exists sp_insert_pessoas;
delimiter $$
create procedure sp_insert_pessoas(nome varchar(100), sexo char(1), data_nascimento date)
begin
	declare prox_id int default 0;
    
    set prox_id = (select coalesce(max(id),0) + 1 from pessoas);
    
    insert into pessoas
		values(prox_id, nome, sexo, data_nascimento);

end $$

select * from pessoas
call sp_insert_pessoas('alicne', 'F','2018-04-05')

delete from pessoas


/*
Crie uma Stored Procedure que mostre quantos Homens e quantas Mulheres têm cadastrados.

*/
drop procedure if exists sp_verifica_quant_por_genero;
delimiter $$
create procedure sp_verifica_quant_por_genero()
begin
	declare var_quant_homens int default 0;
	declare var_quant_mulheres int default 0;
    
    set var_quant_homens = (select count(id) from pessoas where sexo='M');
    set var_quant_mulheres = (select count(id) from pessoas where sexo='F');
    
    select concat('Existem cadastrados ', var_quant_homens, ' homens e ',var_quant_mulheres,' mulheres.') as mensagem;

end $$
call sp_verifica_quant_por_genero();

-- outra abordagem sem msgs.. apenas o resultado direto.

SELECT sexo, COUNT(*) AS quantidade 
    FROM pessoas
    GROUP BY sexo;



/*
Crie uma Stored Procedure que mostre quantos Homens são menores e maiores de idade,
 e quantas Mulheres são maiores e menores de idade.

*/
drop procedure if exists sp_verifica_idade;
delimiter $$
create procedure sp_verifica_idade()
begin
	SELECT 	'homens_maiores' as genero, count(id) as quantidade
	FROM 	pessoas
	where 	sexo='M' and year(current_date)-year(data_nascimento) > 18
	union 
	SELECT 	'homens_menores' as genero, count(id) as quantidade
	FROM 	pessoas
	where 	sexo='M' and year(current_date)-year(data_nascimento) < 18
	union all 
	SELECT 	'mulheres_maiores' as genero, count(id) as quantidade
	FROM 	pessoas
	where 	sexo='F' and year(current_date)-year(data_nascimento) > 18
	union all
	SELECT 	'mulheres_menores' as genero, count(id) as quantidade
	FROM 	pessoas
	where 	sexo='F' and year(current_date)-year(data_nascimento) < 18;
end $$

call sp_verifica_idade();

/*
	outra abordagem
    
*/
delimiter $$
CREATE PROCEDURE IF NOT EXISTS homens_mulheres_maior_de_idade_procedure()
BEGIN

select sexo,
		case 	when maior_de_idade = 0 then "menor"
				else "maior" end as tipo,
		quantidade 
	from (
			SELECT sexo, (TIMESTAMPDIFF(YEAR, data_nascimento, NOW()) >= 18) AS maior_de_idade, COUNT(*) AS quantidade 
			FROM pessoas
			GROUP BY sexo, maior_de_idade
			ORDER BY sexo
        ) as consulta;
END $$
call homens_mulheres_maior_de_idade_procedure()





