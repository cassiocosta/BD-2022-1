SELECT * FROM livrariaDB.assuntos;

-- 3) 
delete from editoras where nome like 'banco_ de dado_ distribuido_';

-- 4) 
select nome, cpf
from autores
where data_nascimento >'1990-01-01';

-- 5) 
SELECT matricula, nome from autores WHERE endereco LIKE 'RIO DE JANEIRO%'; 

-- f) Atualize para zero o preço de todos os livros onde a data de lançamento for 
-- nula ou onde seu preço atual for inferior a R$ 55,00.

update livros 
	set preco = 0
where 	data_lancamento is null or preco<55;

-- h) Escreva o comando para contar quantos são os autores cadastrados na tabela AUTORES.
select count(id)
from 	autores


-- i) Escreva o comando que apresenta qual o número médio de autores de cada livro. Você deve utilizar, novamente, a tabela AUTOR_LIVRO. 
-- refatorando.. seria quantos autores tem por livo
-- qual a média de autores

select livro_id, avg(autor_id)
from autores_livros
group by livro_id

select avg(quantos) as media_autores
from 
	(
		select livro_id, count(autor_id) quantos
		from autores_livros
		group by livro_id
	)
as consulta

select *
from 
	(
		select livro_id, count(autor_id) quantos
		from autores_livros
		group by livro_id
	)
as consulta
where quantos >=2

-- j monstrando o nome do livro
select l.id, l.titulo, count(autor_id) quantos
from autores_livros al
		inner join livros l 
			on l.id = al.livro_id
group by livro_id, l.titulo
having count(autor_id)<=2


-- l Apresente o preço máximo, o preço mínimo e o preço médio dos livros cujos assuntos
--  são ‘S’ ou ‘P’ ou ‘B’, para cada código de editora.

select max(preco) as maximo, min(preco) as minimo, avg(preco) as medio  
from livros
where assunto_id in('B','P')

-- consultas aninhadas para usar no where ou having
-- in [not] in
-- exists [not] exists


-- 4)
-- a)
 select 	titulo, preco,
		preco + ((preco * 10)/100) as opcao_1, 
        preco * 1.10 as opcao_10, 
        preco * 1.15 as opcao_15, 
        preco * 1.20 as opcao_20
 
 from livros
 where	data_lancamento is not null and data_lancamento <= current_date
	

 
-- 4 - c 
-- Escreva o comando que apresente uma listagem dos nomes dos autores e do seu ano e mês de nascimento, 
-- para os autores brasileiros e que tem livros ainda não lançados. A listagem deve estar ordenada em ordem crescente de nome.

select 	a.nome, year(l.data_nascimento) as ano, month(l.data_nascimento) as mes
from 	autores a
			INNER JOIN autores_livros al
				on a.id = al.autor_id
			INNER JOIN livros l
				on l.id = al.livros_id
where	a.nacionalidade like UPPER('%brasil%') and l.data_lancamento is  null and l.data_lancamento > current_date
order by nome asc


