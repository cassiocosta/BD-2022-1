/*
4 – Faça um trigger para alterar o estoque de um produto quando ocorrer quaisquer alterações na tabela orçamentos_produtos. 
Também irá alterar o estoque, quando um ítem na tabela orçamentos_Produtos for cancelado. Isso ocorre quando o 
campo Orp_Status recebe o valor 2.

quaisquer alterações???
orcamentos_produtos

*/

DROP TRIGGER IF EXISTS update_estoque_ins_orcamento_prod;
DELIMITER $$
CREATE TRIGGER update_estoque_ins_orcamento_prod AFTER INSERT ON orcamentos_produtos
	FOR EACH ROW	
BEGIN
		UPDATE produtos SET prd_qde_estoque = prd_qtd_estoque - new.orp_qtd 
        WHERE prd_codigo = new.prd_codigo;
END $$

produto 
coca cola		estoque 12

orçamento  produto Num 
1000 - coca cola - 1 opr_status 0
1002 - COCA cola - 2 orp_status 2
1002 - fanta uva - 1 orp_status 0



DROP TRIGGER IF EXISTS update_estoque;
DELIMITER $$
CREATE TRIGGER update_estoque AFTER UPDATE ON orcamentos_produtos
	FOR EACH ROW	
BEGIN
	IF(OLD.Orp_status <> 2 and NEW.Orp_Status = 2) THEN-- FOI CANCELADO?
		UPDATE produtos SET prd_qde_estoque = prd_qtd_estoque + new.orp_qtd 
        WHERE prd_codigo = new.prd_codigo;
	END IF;
END $$
DELIMITER $$

--  SE DELETAR UM ORÇAMENTO PRODUTO ESTORNAR O ESTOQUE
DROP TRIGGER IF EXISTS update_estoque_del_orcamento_prod;
DELIMITER $$
CREATE TRIGGER update_estoque_del_orcamento_prod AFTER DELETE ON orcamentos_produtos
	FOR EACH ROW	
BEGIN
		IF(OLD.Orp_Status <> 2) THEN-- NAO TA CANCELADO?
			UPDATE produtos SET prd_qde_estoque = prd_qtd_estoque + new.orp_qtd 
			WHERE prd_codigo = new.prd_codigo;
		END IF;
	
END $$

-- Faça um trigger para armazenar em uma tabela chamada produtos_atualizados (prd_codigo, 
-- prd_qtd_anterior, prd_qtd_atualizada, prd_valor) quando ocorrer quaisquer alterações nos atributos da tabela produtos. 
-- No entanto, caso a alteração atribua o valor zero para o atributo prd_qtd_estoque, a tabela produtos_em_falta deverá ser 
-- alimentada com as mesmas informações da tabela produto, exceto o atributo prd_valor. Além disso, 
-- o atributo prd_status do produto atualizado deve ser modificado para NULL e o atributo orp_status de todos os 
-- orcamentos_produtos desse produto deverá ser modificado também para NULL. 


DROP TRIGGER IF EXISTS controla_ocorrencias_produtos;
DELIMITER $$
CREATE TRIGGER controla_ocorrencias_produtos BEFORE UPDATE ON produtos
	FOR EACH ROW	
BEGIN
		insert into produtos_atualizados (prd_codigo, prd_qtd_anterior, prd_qtd_atualizada, prd_valor)
			values (new.prd_codigo, old.prd_qtd_estoque, new.prd_qtd_estoque, new.prd_valor);
            
		IF(new.prd_qtd_estoque = 0) THEN
			insert into produtos_em_falta
            value(new.prd_codigo, new.prd_descricao, new.prd_status, new.prd_falta);
		END IF;
        
        set new.prd_status = null;
        
        update orcamentos_produtos set orp_status = null
        where prd_codigo = new.prd_codigo;
        
END $$


