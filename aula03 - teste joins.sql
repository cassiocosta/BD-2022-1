SELECT * FROM clientes;
select * from transacoes;
SET SQL_SAFE_UPDATES = 0;


insert into transacoes (data_emissao,descricao,cliente_id)
	values 
		('2020-01-01','teste1',1),
		('2020-01-01','teste2',1),
		('2020-01-01','teste3',1),
		('2020-01-01','teste4',1),
		('2020-01-01','teste5',1),
		('2020-02-01','teste6',2),
		('2020-02-01','test74',2),        
		('2020-02-01','teste8',2),
		('2020-02-01','teste9',3),
		('2020-03-01','test44',3),
		('2020-03-01','test45',3),
		('2020-03-01','test46',4),
		('2020-04-01','teste74',5),
		('2020-04-01','teste84',5),
		('2020-04-01','teste94',5),
		('2020-04-01','teste44',5),
		('2020-04-01','teste64',5),
		('2020-05-01','teste4',5);


-- FUS que retorne todas as transacoes e seus nomes dos respectivos clientes

SELECT	*
FROM 	clientes c 
			INNER JOIN transacoes t ON c.id = t.cliente_id
WHERE 	t.data_emissao between '2020-02-01' and '2020-02-28'

-- FUS que conte quantas transações tem por cliente. 


id			num_trans
1			5
2			2
3			7

-- funções de agregação? quais são?
AVG, MAX, MIN, SUM, COUNT
select count(id) as num from transacoes


select cliente_id, count(id)
FROM 	transacoes 
GROUP BY cliente_id

-- qual sala tem mais alunos?
select cliente_id, clientes.nome, count(transacoes.id) as contagem
FROM 	transacoes inner join clientes on clientes.id = transacoes.cliente_id
GROUP BY cliente_id, clientes.nome
ORDER BY contagem DESC
LIMIT 1

-- insira um campo valor na tabela transaçoes e atualize o valor de cada
alter table transacoes 
	add column valor decimal(18,2);

-- qual o cliente que mais gastou com transacoes?
SELECT clientes.nome, SUM(transacoes.valor) as total FROM transacoes
	INNER JOIN clientes 
		ON clientes.id = transacoes.cliente_id
GROUP BY clientes.nome
ORDER BY total DESC
LIMIT 1;

-- quero saber os gastos de transações por cliente e me mostra somente aqueles que gastaram acima de 100...

SELECT clientes.nome, SUM(transacoes.valor) as total 
FROM transacoes
	INNER JOIN clientes 
		ON clientes.id = transacoes.cliente_id
GROUP BY clientes.nome
HAVING total > 100
ORDER BY total DESC

-- -- quero saber os gastos de transações por cliente e me mostra somente aqueles que gastaram acima de 100...
-- porem considere somente as transações acima de 50.

SELECT clientes.nome, SUM(transacoes.valor) as total 
FROM transacoes
	INNER JOIN clientes 
		ON clientes.id = transacoes.cliente_id
WHERE 	valor > 50	
GROUP BY clientes.nome
HAVING total > 100
ORDER BY total DESC
limit 1

select * from transacoes where cliente_id = 5
        
        
      