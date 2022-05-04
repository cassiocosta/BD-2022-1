-- FUSP que inclua e autalize livros 
DROP PROCEDURE IF EXISTS crud_livros_proc;
DELIMITER $$
CREATE PROCEDURE 
	crud_livros_proc(
		p_oper char(1),
		p_id int, 	
		p_titulo varchar(45),
        p_data_lancamento date,
        p_editora_id int, 
        p_assunto_id char(1),
        p_preco decimal(18,2))
BEGIN
DECLARE prox_id int;
DECLARE mensagem varchar(50);
DECLARE falha boolean DEFAULT false;
	IF(p_oper = 'I') THEN
		set prox_id = (select max(id) + 1 from livros);
		insert into livros (id, titulo, data_lancamento, editora_id, assunto_id, preco)
		values (prox_id, p_titulo, p_data_lancamento, p_editora_id, p_assunto_id, p_preco);
        set mensagem = 'Inserido';
    ELSEIF(p_oper = 'U') THEN
		update livros set 
			titulo = p_titulo,
            data_lancamento = p_data_lancamento,
            editora_id = p_editora_id, 
            assunto_id = p_assunto_id,
            preco = p_preco
		where	id = p_id;
        set mensagem = 'Atualizado ';
	ELSE
		set falha = true;
		set mensagem = 'Informe I para inserir e U para atualizar';
    END IF;
	    
    IF(falha) THEN
		select mensagem;
    ELSE
		select concat(mensagem,'com sucesso.');
	END IF;
END $$
DELIMITER ;

CALL crud_livros_proc('U',2,'LP em C - 2022','2022-06-22',1,'B',98); 

select * from livros
