-- view
SET SQL_SAFE_UPDATES = 0;

-- FUS que retorne os autores e seus livros cadastrados
CREATE VIEW autores_livros_view
as
select 	livro_id, autor_id, titulo, data_lancamento,
		editora_id, assunto_id, preco, nome as autor, data_nasc
from 	autores_livros al
			inner join livros l
				on l.id = al.livro_id
			inner join autores a
				on a.id = al.autor_id;

-- me mostra as editoras que tem livros lançados.
select distinct e.nome, v.titulo, data_lancamento
from 	autores_livros_view v
			inner join editoras e
				on e.id = editora_id
where data_lancamento <= current_date and data_lancamento is not null

update livros set data_lancamento=null where data_lancamento = '0000-00-00'

select * from livros where data_lancamento is null

produtos (id, nome, valor, saldo) 
Orcamentos ( id, data, status)

Orçamentos_itens(id_prod, id_orc, valor_unit, quantidade, valor_total_item)


create view orcamentos_view
as
select oi.orcamento_id, oi.produto_id, data, status, nome, saldo, valor_unit, quantidade, valor_total_item 
from 	orcamentos o
			inner join orcamentos_itens oi
				on oi.orcamento_id = o.id
			inner join produtos p
				on p.id = oi.produto_id

select 	sum(valor_total_item) as total
from orcamentos_view
where data between '2022-03-01' and '2022-03-31'

select orcamento_id, data, status
from orcamentos_view
where nome like 'computador%'


Os 10 produtos mais orçados no mês de setembro de 2014 e
 que ainda tem saldo em estoque. Somente os produtos com o valor acima de R$ 500.00.
 
select produto_id, nome, count(produto_id) as quantas_vezes
from orcamentos_view
where data between '2014-09-01' and '2014-09-30' and 
	saldo>0 and valor > 500
group by produto_id, nome
order by quantas_vezes desc
limit 10