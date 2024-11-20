# CREATE DATABASE
DROP DATABASE if EXISTS conta_bancaria;
CREATE DATABASE if NOT EXISTS conta_bancaria;
USE conta_bancaria;

# CREATE USER
DROP USER if EXISTS 'gerente_banco';
CREATE USER if NOT EXISTS 'gerente_banco' IDENTIFIED BY 'banco123';
GRANT ALL PRIVILEGES ON conta_bancaria.* TO 'gerente_banco';
FLUSH PRIVILEGES;

# DROP TABLE
DROP TABLE if EXISTS conta_poupanca;
DROP TABLE if EXISTS indice_remuneracao;
DROP TABLE if EXISTS cotacao;
DROP TABLE if EXISTS conta_salario;
DROP TABLE if EXISTS conta_especial;
DROP TABLE if EXISTS conta_corrente;
DROP TABLE if EXISTS movimentacao;
DROP TABLE if EXISTS evento;
DROP TABLE if EXISTS conta_bancaria;
DROP TABLE if EXISTS banco;
DROP TABLE if EXISTS telefone;
DROP TABLE if EXISTS pessoa_juridica;
DROP TABLE if EXISTS pessoa_fisica;
DROP TABLE if EXISTS pessoa;
DROP TABLE if EXISTS localidade;

# CREATE TABLE
CREATE TABLE if NOT EXISTS localidade (
	id          BIGINT       AUTO_INCREMENT,
	cep         BIGINT       NOT NULL UNIQUE,
	estado      VARCHAR(80)  NOT NULL,
	cidade      VARCHAR(80)  NOT NULL,
	bairro      VARCHAR(50)  NOT NULL,
	logradouro  VARCHAR(100) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE if NOT EXISTS pessoa (
	id             BIGINT AUTO_INCREMENT,
	id_localidade  BIGINT NOT NULL,
	num_endereco   INT    NOT NULL,
	compl_endereco VARCHAR(32),
	situacao       INT    NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (id_localidade) REFERENCES localidade(id)
);

CREATE TABLE if NOT EXISTS pessoa_fisica (
	id_pessoa  BIGINT,
	cpf        VARCHAR(14)  NOT NULL UNIQUE,
	nome       VARCHAR(100) NOT NULL,
	dt_nasc    DATE         NOT NULL,
	sexo       BIT(1)       NOT NULL,
	PRIMARY KEY (id_pessoa),
	FOREIGN KEY (id_pessoa) REFERENCES pessoa(id)
);

CREATE TABLE if NOT EXISTS pessoa_juridica (
	id_pessoa       BIGINT,
	cnpj            VARCHAR(18)  NOT NULL UNIQUE,
	razao_social    VARCHAR(100) NOT NULL,
	nome_fantasia   VARCHAR(50)  NOT NULL,
	inscr_estadual  VARCHAR(32)  NOT NULL,
	PRIMARY KEY (id_pessoa),
	FOREIGN KEY (id_pessoa) REFERENCES pessoa(id)
);

CREATE TABLE if NOT EXISTS telefone (
	id        BIGINT      AUTO_INCREMENT,
	id_pessoa BIGINT      NOT NULL,
	numero    VARCHAR(15) NOT NULL,
	tipo      INT         NOT NULL,
	PRIMARY KEY (id, id_pessoa),
	FOREIGN KEY (id_pessoa) REFERENCES pessoa(id)
);

CREATE TABLE if NOT EXISTS banco (
	id             BIGINT       AUTO_INCREMENT,
	nome           VARCHAR(100) NOT NULL,
	mascaraAgencia VARCHAR(50)  NOT NULL,
	mascaraConta   VARCHAR(50)  NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE if NOT EXISTS conta_bancaria (
	id            BIGINT        AUTO_INCREMENT,
	id_banco      BIGINT        NOT NULL,
	num_agencia   BIGINT        NOT NULL,
	saldo         DECIMAL(11,2) NOT NULL,
	data_abertura DATE          NOT NULL,
	id_titular    BIGINT        NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (id_banco)   REFERENCES banco  (id),
	FOREIGN KEY (id_titular) REFERENCES pessoa (id)
);

CREATE TABLE if NOT EXISTS evento (
	id                BIGINT       AUTO_INCREMENT,
	descricao         VARCHAR(100) NOT NULL,
	tipo_movimentacao INT          NOT NULL,
	situacao          INT          NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE if NOT EXISTS movimentacao (
	id_conta_bancaria BIGINT        AUTO_INCREMENT,
	data_movimentacao DATE          NOT NULL,
	id_evento         BIGINT        NOT NULL,
	valor             DECIMAL(11,2) NOT NULL,
	PRIMARY KEY (id_conta_bancaria),
	FOREIGN KEY (id_conta_bancaria) REFERENCES conta_bancaria (id),
	FOREIGN KEY (id_evento)         REFERENCES evento         (id)
);

CREATE TABLE if NOT EXISTS conta_corrente (
	id_conta_bancaria    BIGINT        NOT NULL,
	valor_cesta_servicos DECIMAL(11,2) NOT NULL,
	limite_pix_noturno   DECIMAL(11,2) NOT NULL,
	PRIMARY KEY (id_conta_bancaria),
	FOREIGN KEY (id_conta_bancaria) REFERENCES conta_bancaria (id)
);

CREATE TABLE if NOT EXISTS conta_especial (
	id_conta_corrente  BIGINT        NOT NULL,
	limite_credito     DECIMAL(11,2) NOT NULL,
	data_vcto_contrato DATE          NOT NULL,
	PRIMARY KEY (id_conta_corrente),
	FOREIGN KEY (id_conta_corrente) REFERENCES conta_corrente (id_conta_bancaria)
);

CREATE TABLE if NOT EXISTS conta_salario (
	id_conta_corrente     BIGINT        NOT NULL,
	cnpj_vinculado        VARCHAR(14)   NOT NULL,
	limite_consignado     DECIMAL(11,2) NOT NULL,
	limite_antecipado_mes DECIMAL(11,2) NOT NULL,
	permite_antecipar_13o BIT(1)        NOT NULL,
	PRIMARY KEY (id_conta_corrente),
	FOREIGN KEY (id_conta_corrente) REFERENCES conta_corrente  (id_conta_bancaria),
	FOREIGN KEY (cnpj_vinculado)    REFERENCES pessoa_juridica (cnpj)
);

CREATE TABLE if NOT EXISTS cotacao (
	id           BIGINT AUTO_INCREMENT,
	data_cotacao DATE   NOT NULL,
	situacao     INT    NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE if NOT EXISTS indice_remuneracao (
	id            BIGINT       AUTO_INCREMENT,
	descricao     VARCHAR(100) NOT NULL,
	periodicidade INT          NOT NULL,
	situacao      INT          NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE if NOT EXISTS conta_poupanca (
	id_conta_bancaria      BIGINT       NOT NULL,
	id_indice_remuneracao  BIGINT       NOT NULL,
	perc_rendimento_real   DECIMAL(4,2) NOT NULL,
	PRIMARY KEY (id_conta_bancaria),
	FOREIGN KEY (id_conta_bancaria)     REFERENCES conta_bancaria     (id),
	FOREIGN KEY (id_indice_remuneracao) REFERENCES indice_remuneracao (id)
);