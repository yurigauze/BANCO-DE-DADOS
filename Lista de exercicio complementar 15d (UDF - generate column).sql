Lista de Exercícios II – Colunas Virtuais e Funções Definidas pelo Usuário
1.	Considerando um cenário em que a tabela PARCELA_PAGAR possui poucas incidências de inserções de novos registros e muitas requisições de consulta. Diante do exposto, interprete a melhor solução para implementar uma coluna gerada VIRTUAL ou ARMAZENADA que indique se a parcela está quitada ou não. Justifique a solução.
use BANCO;
ALTER TABLE PARCELA_PAGAR ADD PAGO CHAR(1) AS (CASE WHEN VALOR=QUITADO THEN "S" ELSE "N" END) STORED;
SELECT * FROM PARCELA_PAGAR;
COMO É UMA COLUNA QUE POSSUIRA MUITAS CONSULTAS É MELHOR O DADO JA ESTAR ARMAZENADO.

2.	Em relação à coluna TOTAL da tabela COMPRA, a coluna respeita todas as regras da normalização? Caso não, identifique qual normalização não é respeitada, explique os possível problemas que podem ser gerados e implemente uma possível solução para minimizar estes problemas. Justifique a solução.
NÃO ESTA NORMALIZADA, VISTO QUE A TABELA COMPRA E A TABELA ICOMPRA QUE FAZEM REFERENCIA POSSUEM DADOS REPETIDOS. ASSIM GERANDO REDUNDANCIA. UM DAS SOLUÇÃO SERIA DEFINIR A COLUNA DESCONTO DA TABELA COPRA COMO UMA FK DA TABELA ICOMPRA

3.	Escreva uma função que retorne a diferença prevista entre pagamentos e recebimentos à vista do dia. Em seguida, escreva o comando para testar a função.

DELIMITER // 
CREATE FUNCTION RECEBER(DATA DATE)
RETURNS FLOAT DETERMINISTIC
BEGIN
	DECLARE DIFERENCA FLOAT ; 
    DECLARE RECEBER FLOAT;
    DECLARE PAGAR FLOAT;
    DECLARE DATA DATE;
    SET DATA = DATA;
		SELECT TOTAL INTO RECEBER FROM VENDA WHERE date(VENDA.DATA_CADASTRO) = DATA AND VENDA.TIPO = 1;
        SELECT TOTAL INTO PAGAR FROM COMPRA WHERE date(VENDA.DATA_CADASTRO) = DATA AND COMPRA.TIPO = 1;
        SET DIFERENCA = RECEBER - PAGAR;
	RETURN DIFERENCA;
END;
//
DELIMITER ;
SELECT RECEBER(2022-12-09);

4.	Elabore uma função que receba como parâmetro o código de uma venda, verifique e retorne a quantidade parcelas a receber geradas. Escreva o comando para testar a função e explique se a função criada é de validação, verificação, segurança, simplificação ou de geração de dados/informação.
DELIMITER // 
CREATE FUNCTION RECEBER(CODIGO_VENDA INT)
RETURNS INT DETERMINISTIC
BEGIN 
    DECLARE RECEBER INT;
		SELECT QTDR_PARC_PENDENTE INTO RECEBER FROM CRECEBER, VENDA WHERE CRECEBER.VENDA_ID = VENDA.ID AND VENDA.ID = CODIGO_VENDA;
	RETURN RECEBER;
END;
//
DELIMITER ;

FUNÇÃO DE GERAÇÃO DE DADOS, POIS IRA BUSCAR A QUANTIDADE DE PARCELAS E RETORNAR O VALOR

SELECT RECEBER(1);

5.	A coluna CONTATO da tabela CLIENTE foi criada especificamente para registros de empresas – pessoa jurídica. Neste sentido, escreva uma única função que verifique se somente registros de empresas possuem contato. Em seguida, escreva o comando para testar a função.

DELIMITER // 
DROP function CONTATO;
CREATE FUNCTION CONTATO(CLIENTE INT)
RETURNS BOOLEAN DETERMINISTIC
BEGIN 
    DECLARE VERDADEIRO BOOLEAN DEFAULT TRUE;
		DECLARE CNPJ INT;
        DECLARE QUANTIDADE INT;
        DECLARE TELEFONE VARCHAR(12);
        SELECT FONE INTO TELEFONE FROM CLIENTE WHERE CLIENTE.ID = CLIENTE;
		SELECT QLENGTH(CPF_CNPJ) INTO QUANTIDADE FROM CLIENTE WHERE CLIENTE.ID = CLIENTE;
        IF QUANTIDADE = 14 AND TELEFONE is null THEN
        BEGIN
			SET VERDADEIRO = FALSE;
		END;
        END IF;
	RETURN VERDADEIRO;
END;
//
DELIMITER ;

SELECT CONTATO(1);
