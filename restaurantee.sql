create database restaurante;

CREATE TABLE Mesa (
    idMesa INT PRIMARY KEY AUTO_INCREMENT,
    numero INT,
    status ENUM('Livre', 'Ocupada', 'Sobremesa', 'Ocupada-Ociosa')
);

INSERT INTO Mesa (numero, status) VALUES
(1, 'Livre'),
(2, 'Ocupada'),
(3, 'Sobremesa'),
(4, 'Livre'),
(5, 'Ocupada-Ociosa'),
(6, 'Ocupada'),
(7, 'Livre'),
(8, 'Sobremesa'),
(9, 'Ocupada'),
(10, 'Livre');


CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100)
);

INSERT INTO Cliente (nome) VALUES
('João Basso'),
('Matheus Godoi'),
('Pedro Techuk'),
('Erick Presley'),
('Pedro Costa'),
('Luiza Almeida'),
('Fernanda Souza'),
('Marcos Lima'),
('Roberta Martins'),
('Rafael Barbosa');


CREATE TABLE Produto (
    idProduto INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(50),
    precoUnitario DECIMAL(10,2),
    quantidadeEstoque INT,
    estoqueMinimo INT,
    marca VARCHAR(100)
);

INSERT INTO Produto (codigo, precoUnitario, quantidadeEstoque, estoqueMinimo, marca) VALUES
('A001', 15.50, 100, 10, 'Marca A'),
('A002', 25.00, 50, 5, 'Marca B'),
('A003', 10.00, 200, 20, 'Marca C'),
('A004', 5.50, 150, 15, 'Marca D'),
('A005', 12.00, 80, 8, 'Marca E'),
('A006', 30.00, 30, 3, 'Marca F'),
('A007', 20.00, 120, 12, 'Marca G'),
('A008', 18.00, 60, 6, 'Marca H'),
('A009', 7.50, 90, 9, 'Marca I'),
('A010', 22.00, 40, 4, 'Marca J');

CREATE TABLE FormaPagamento (
    idFormaPagamento INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(100)
);

INSERT INTO FormaPagamento (descricao) VALUES
('Dinheiro'),
('Cartão de Crédito'),
('Cartão de Débito'),
('Pix'),
('Transferência Bancária'),
('Cheque'),
('Vale Refeição'),
('Vale Alimentação'),
('PayPal'),
('Crédito Loja');

CREATE TABLE Pedido (
    idPedido INT PRIMARY KEY AUTO_INCREMENT,
    idMesa INT,
    dataHora DATETIME,
    idFormaPagamento INT,
    valorTotal DECIMAL(10,2),
    FOREIGN KEY (idMesa) REFERENCES Mesa(idMesa),
    FOREIGN KEY (idFormaPagamento) REFERENCES FormaPagamento(idFormaPagamento)
);

INSERT INTO Pedido (idMesa, dataHora, idFormaPagamento, valorTotal) VALUES
(1, '2024-11-24 12:30:00', 1, 150.00),
(2, '2024-11-24 13:00:00', 2, 200.00),
(3, '2024-11-24 13:30:00', 3, 50.00),
(4, '2024-11-24 14:00:00', 4, 300.00),
(5, '2024-11-24 14:30:00', 5, 80.00),
(6, '2024-11-24 15:00:00', 6, 120.00),
(7, '2024-11-24 15:30:00', 7, 90.00),
(8, '2024-11-24 16:00:00', 8, 60.00),
(9, '2024-11-24 16:30:00', 9, 170.00),
(10, '2024-11-24 17:00:00', 10, 210.00);

CREATE TABLE ItemPedido (
    idItemPedido INT PRIMARY KEY AUTO_INCREMENT,
    idPedido INT,
    idProduto INT,
    quantidade INT,
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
    FOREIGN KEY (idProduto) REFERENCES Produto(idProduto)
);

INSERT INTO ItemPedido (idPedido, idProduto, quantidade) VALUES
(1, 1, 3),
(1, 2, 1),
(2, 3, 2),
(2, 4, 4),
(3, 5, 1),
(4, 6, 2),
(5, 7, 3),
(6, 8, 1),
(7, 9, 2),
(8, 10, 1);

CREATE TABLE MesaCliente (
    idMesaCliente INT PRIMARY KEY AUTO_INCREMENT,
    idMesa INT,
    idCliente INT,
    FOREIGN KEY (idMesa) REFERENCES Mesa(idMesa),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

INSERT INTO MesaCliente (idMesa, idCliente) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

/*a) Exibir as vendas por: Nome do funcionário (cliente), mesas atendidas e valor total gasto*/

SELECT Cliente.nome AS NomeFuncionario,
Mesa.numero AS NumeroMesa,
SUM(Pedido.valorTotal) AS ValorTotalGasto
FROM Pedido
JOIN Mesa ON Pedido.idMesa = Mesa.idMesa
JOIN MesaCliente ON Mesa.idMesa = MesaCliente.idMesa
JOIN Cliente ON MesaCliente.idCliente = Cliente.idCliente
GROUP BY Cliente.nome, Mesa.numero;

/*b) Exibir todos os produtos consumidos por uma determinada mesa*/
SELECT 
Mesa.numero AS NumeroMesa,
Produto.codigo AS CodigoProduto,
Produto.marca AS MarcaProduto,
Produto.precoUnitario AS PrecoUnitario,
ItemPedido.quantidade AS QuantidadeConsumida
FROM ItemPedido
JOIN Pedido ON ItemPedido.idPedido = Pedido.idPedido
JOIN Mesa ON Pedido.idMesa = Mesa.idMesa
JOIN Produto ON ItemPedido.idProduto = Produto.idProduto
WHERE Mesa.numero = 1;
    
/*c) Implementar uma Stored Procedure para redefinir o status de uma mesa para "Livre"*/
DELIMITER $$

CREATE PROCEDURE RedefinirMesaLivre(IN numeroMesa INT)
BEGIN
    UPDATE Mesa
    SET status = 'Livre'
    WHERE numero = numeroMesa;
END $$

DELIMITER ;

CALL RedefinirMesaLivre(1); -- Substitua "1" pelo número da mesa desejada
