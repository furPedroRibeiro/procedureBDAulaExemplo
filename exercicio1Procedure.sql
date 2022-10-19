DELIMITER $$
CREATE PROCEDURE faz_pedido(IN vendedor INT, IN quem INT, IN oque INT, IN quanto INT)
BEGIN
		INSERT INTO pedido (id_vendedor, id_cliente, id_produto, qtd) VALUES (vendedor, quem, oque, quanto);
		UPDATE produto SET qtd = qtd-quanto WHERE cd = oque;
        SET @pedido = LAST_INSERT_ID();
        SET @valor = 0;
        SELECT valor INTO @valor FROM produto WHERE cd = oque; 
        INSERT INTO comissao (id_pedido, id_vendedor, valor) VALUES (@pedido, vendedor, (@valor/100*5)*quanto);
END $$
DELIMITER ;	

DROP PROCEDURE faz_pedido;

CALL faz_pedido(1, 5, 3, 5);

SELECT * FROM pedido;

SELECT * FROM produto;

SELECT * FROM comissao;

DELIMITER $$
CREATE PROCEDURE cancelar_pedido(IN qual INT)
BEGIN
	SET @quanto = 0;
    SET @oque = 0;
	SELECT qtd INTO @quanto FROM pedido WHERE cd = qual;
    SELECT id_produto INTO @oque FROM pedido WHERE cd = qual;
    UPDATE produto SET qtd = qtd+@quanto WHERE cd = @oque;
    DELETE FROM comissao WHERE id_pedido = qual;
    DELETE FROM pedido WHERE cd = qual;
END $$
DELIMITER ;

DROP PROCEDURE cancelar_pedido;

CALL cancelar_pedido(1);

SELECT * FROM produto;

SELECT * FROM comissao;

SELECT * FROM pedido;

/*
	DELIMITER $$
	CREATE PROCEDURE faz_pedido(IN quem INT, IN oque INT, IN quanto INT)
	BEGIN
		INSERT INTO pedido (id_cliente, id_produto, qtd) VALUES (quem, oque, quanto);
		UPDATE produto SET qtd = qtd-quanto WHERE cd = oque;
	END $$
	DELIMITER ;

	como excluir procedimento ou alterá-lo(impossível alterar ele, excluir obrigatóriamente)
		drop procedure faz_pedido;

BANCO 
DROP DATABASE sistema;
CREATE DATABASE sistema;
use sistema;

CREATE TABLE produto(
cd INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(100),
valor DECIMAL(10,2),
qtd INT);

INSERT INTO produto (nome, valor, qtd) 
VALUES
("carro", 25.50, 1000),
("pasta", 50, 1000),
("ovo", 200, 1000),
("leite", 48, 1000);

CREATE TABLE cliente(
cd INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(100));

INSERT INTO cliente (nome) VALUES
("Rodolfo"),
("Wellington"),
("Jonas"),
("Oswaldo"),
("Paulo");

CREATE TABLE vendedor(
cd INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(100)
);
INSERT INTO vendedor (nome) VALUES
("Vendedor 1"),
("Vendedor 2");

CREATE TABLE pedido(
cd INT PRIMARY KEY AUTO_INCREMENT,
id_vendedor INT,
id_cliente INT,
id_produto INT,
qtd INT,
FOREIGN KEY (id_produto) REFERENCES produto (cd),
FOREIGN KEY (id_cliente) REFERENCES cliente (cd),
FOREIGN KEY (id_vendedor) REFERENCES vendedor (cd)
);
CREATE TABLE comissao(
id_pedido INT,
id_vendedor INT,
valor DECIMAL(10,2),
FOREIGN KEY (id_pedido) REFERENCES pedido (cd),
FOREIGN KEY (id_vendedor) REFERENCES vendedor (cd)
);*/
