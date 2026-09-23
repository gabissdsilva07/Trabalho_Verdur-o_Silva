CREATE DATABASE IF NOT EXISTS Verdurão_Silva;
USE Verdurão_Silva;

DROP TABLE IF EXISTS Perdas_Descartes;
DROP TABLE IF EXISTS Entregas;
DROP TABLE IF EXISTS Itens_Venda;
DROP TABLE IF EXISTS Vendas;
DROP TABLE IF EXISTS Funcionarios;
DROP TABLE IF EXISTS Clientes;
DROP TABLE IF EXISTS Itens_Compra;
DROP TABLE IF EXISTS Compras_Entrada;
DROP TABLE IF EXISTS Produtos;
DROP TABLE IF EXISTS Categorias;
DROP TABLE IF EXISTS Fornecedores;

CREATE TABLE IF NOT EXISTS Fornecedores (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome_empresa_produtor VARCHAR(100) NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE,
    telefone VARCHAR(20),
    cidade VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(50) NOT NULL, -- Ex: 'Frutas', 'Verduras', 'Legumes'
    descricao TEXT
);

CREATE TABLE IF NOT EXISTS Produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT,
    nome VARCHAR(100) NOT NULL,
    preco_venda DECIMAL(10,2) NOT NULL,
    unidade_medida VARCHAR(10) NOT NULL,
    quantidade_estoque DECIMAL(10,3) DEFAULT 0.000,
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
);

CREATE TABLE IF NOT EXISTS Compras_Entrada (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_fornecedor INT NOT NULL,
    data_compra DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (id_fornecedor) REFERENCES Fornecedores(id_fornecedor)
);

CREATE TABLE IF NOT EXISTS Itens_Compra (
    id_item_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_compra INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade DECIMAL(10,3) NOT NULL,
    preco_custo_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_compra) REFERENCES Compras_Entrada(id_compra),
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

CREATE TABLE IF NOT EXISTS Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    telefone VARCHAR(20),
    limite_credito DECIMAL(10,2) DEFAULT 0.00
);

CREATE TABLE IF NOT EXISTS Funcionarios (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    telefone VARCHAR(20),
    data_admissao DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS Vendas (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NULL, 
    id_funcionario INT NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    forma_pagamento VARCHAR(30) NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionarios(id_funcionario)
);

CREATE TABLE IF NOT EXISTS Itens_Venda (
    id_item_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade DECIMAL(10,3) NOT NULL,
    preco_aplicado DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venda) REFERENCES Vendas(id_venda),
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

CREATE TABLE IF NOT EXISTS Entregas (
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT UNIQUE NOT NULL,
    id_entregador INT NOT NULL,
    endereco_destino TEXT NOT NULL,
    taxa_entrega DECIMAL(10,2) DEFAULT 0.00,
    status VARCHAR(20) DEFAULT 'Pendente', 
    FOREIGN KEY (id_venda) REFERENCES Vendas(id_venda),
    FOREIGN KEY (id_entregador) REFERENCES Funcionarios(id_funcionario)
);

CREATE TABLE IF NOT EXISTS Perdas_Descartes (
    id_perda INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    quantidade_perdida DECIMAL(10,3) NOT NULL,
    motivo VARCHAR(100) NOT NULL, 
    data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);