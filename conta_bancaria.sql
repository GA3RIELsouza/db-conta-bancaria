# CREATE DATABASE
CREATE DATABASE if NOT EXISTS conta_bancaria;
USE conta_bancaria;

# DROP TABLE
DROP TABLE if EXISTS Telefone_Pessoa;
DROP TABLE if EXISTS Pessoa_Juridica;
DROP TABLE if EXISTS Pessoa_Fisica;
DROP TABLE if EXISTS Pessoa;
DROP TABLE if EXISTS Localidade;

# CREATE TABLE
CREATE TABLE if NOT EXISTS Localidade
(
	ID         BIGINT       AUTO_INCREMENT,
	CEP        BIGINT       NOT NULL UNIQUE,
	Estado     VARCHAR(2)   NOT NULL,
	Cidade     VARCHAR(80)  NOT NULL,
	Bairro     VARCHAR(50)  NOT NULL,
	Logradouro VARCHAR(100) NOT NULL,
	PRIMARY KEY (ID)
);

CREATE TABLE if NOT EXISTS Pessoa
(
	ID             BIGINT AUTO_INCREMENT,
	ID_Localidade  BIGINT NOT NULL,
	Num_Endereco   INT    NOT NULL,
	Compl_Endereco VARCHAR(32),
	Situacao       INT    NOT NULL,
	PRIMARY KEY (ID),
	FOREIGN KEY (ID_Localidade) REFERENCES Localidade(ID)
);

CREATE TABLE if NOT EXISTS Pessoa_Fisica
(
	ID_Pessoa BIGINT,
	CPF       BIGINT       NOT NULL UNIQUE,
	Nome      VARCHAR(100) NOT NULL,
	Dt_Nasc   DATE         NOT NULL,
	Sexo      INT          NOT NULL,
	PRIMARY KEY (ID_Pessoa),
	FOREIGN KEY (ID_Pessoa) REFERENCES Pessoa(ID)
);

CREATE TABLE if NOT EXISTS Pessoa_Juridica
(
	ID_Pessoa      BIGINT,
	CNPJ           VARCHAR(14)  NOT NULL UNIQUE,
	Razao_Social   VARCHAR(100) NOT NULL,
	Nome_Fantasma  VARCHAR(50)  NOT NULL,
	Insrc_Nacional VARCHAR(32)  NOT NULL,
	PRIMARY KEY (ID_Pessoa),
	FOREIGN KEY (ID_Pessoa) REFERENCES Pessoa(ID)
);

CREATE TABLE if NOT EXISTS Telefone_Pessoa
(
	ID        BIGINT AUTO_INCREMENT,
	ID_Pessoa BIGINT,
	Numero    BIGINT NOT NULL,
	Tipo      INT    NOT NULL,
	Situacao  INT    NOT NULL,
	PRIMARY KEY (ID, ID_Pessoa),
	FOREIGN KEY (ID_Pessoa) REFERENCES Pessoa(ID)
);