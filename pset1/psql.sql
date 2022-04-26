/*CRIAR USUARIO*/
CREATE USER yan WITH ENCRYPTED PASSWORD '123' CREATEDB;

/*CRIANDO A DATABASE*/
create database uvv 
 with
 owner = yan
 template = 'template0' 
 encoding = 'UTF8'
 lc_collate = 'pt_BR.UTF-8'
 lc_ctype = 'pt_BR.UTF-8'
 allow_connections = true;

/*DANDO OS PRIVILEGIOS PARA O USER*/
grant all privileges on database uvv to yan with grant option granted by yan;

/*CONECTANDO A DATABASE*/
\c uvv yan

/* CRIANDO SCHEMA*/
CREATE SCHEMA elmasri AUTHORIZATION yan;

/*VERIFICANDO QUAL SCHEMA E O PRINCIPAL*/
SELECT CURRENT_SCHEMA();

/*COLOCAR O SCHEMA CRIADO COMO PRINCIPAL*/
SET SEARCH_PATH TO elmasri, "$user", public;

/*TORNANDO A ALTERACAO PERMANENTE*/
ALTER USER yan
SET SEARCH_PATH TO elmasri, "$user", public;

/*CRIANDO AS TABELAS/*

CREATE TABLE funcionario (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(50),
                sexo CHAR(1),
                salario NUMERIC(10,2),
                cpf_supervisor CHAR(11) NOT NULL,
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT pk_funcionario PRIMARY KEY (cpf)
);
COMMENT ON TABLE elmasri.funcionario IS 'Tabela que guarda os dados dos funcionários.';
COMMENT ON COLUMN elmasri.funcionario.cpf IS 'CPF do funcionário. Vai ser a CHAVE PRIMARIA da tabela.';
COMMENT ON COLUMN elmasri.funcionario.primeiro_nome IS 'Primeiro nome do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.nome_meio IS 'Primeira letra do nome do meio do funcionario.';
COMMENT ON COLUMN elmasri.funcionario.ultimo_nome IS 'Ultimo nome do funcionario.';
COMMENT ON COLUMN elmasri.funcionario.endereco IS 'Residencia do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.sexo IS 'Gênero do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.salario IS 'Salário do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.cpf_supervisor IS 'CPF do supervisor. É uma CHAVE ESTRANGEIRA para a própria tabela.';
COMMENT ON COLUMN elmasri.funcionario.numero_departamento IS 'Número do departamento do funcionário.';

CREATE TABLE dependente (
                nome_dependente VARCHAR(15) NOT NULL,
                cpf_funcionario CHAR(11) NOT NULL,
                sexo CHAR(1),
                data_nascimento DATE,
                parentesco VARCHAR(15),
                CONSTRAINT pk_dependente PRIMARY KEY (nome_dependente, cpf_funcionario)
);
COMMENT ON TABLE elmasri.dependente IS 'Tabela que armazena os dados dos dependentes dos funcionários.';
COMMENT ON COLUMN elmasri.dependente.cpf_funcionario IS 'CPF do funcionário. É CHAVE PRIMARIA desta tabela e CHAVE ESTRANGEIRA da funcionário.';
COMMENT ON COLUMN elmasri.dependente.nome_dependente IS 'Nome do dependente. É uma parte da CHAVE  PRIMARIA desta tabela.';
COMMENT ON COLUMN elmasri.dependente.sexo IS 'Sexo do dependente.';
COMMENT ON COLUMN elmasri.dependente.data_nascimento IS 'Data de nascimento do dependente.';
COMMENT ON COLUMN elmasri.dependente.parentesco IS 'Parentesco do dependente com o funcionário.';



CREATE TABLE departamento (
                numero_departamento INTEGER NOT NULL,
                nome_departamento VARCHAR(15) NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                data_inicio_gerente DATE,
                CONSTRAINT pk_departamento PRIMARY KEY (numero_departamento)
);
COMMENT ON TABLE elmasri.departamento IS 'Tabela armazena os dados dos departamentos.';
COMMENT ON COLUMN elmasri.departamento.numero_departamento IS 'Número do departamento. É a CHAVE PRIMARIA desta tabela.';
COMMENT ON COLUMN elmasri.departamento.nome_departamento IS 'Nome do departamento. Deve ser uma CHAVE ALTERNATIVA.';
COMMENT ON COLUMN elmasri.departamento.cpf_gerente IS 'CPF do gerente do departamento. CHAVE ESTRANGEIRA da tabela funcionário.';
COMMENT ON COLUMN elmasri.departamento.data_inicio_gerente IS 'Data do início do gerente no departamento.';


/*Criando chave alternativa*/
CREATE UNIQUE INDEX departamento_idx
 ON departamento
 ( numero_departamento );

/*Criando chave alternativa*/
CREATE INDEX departamento_idx1
 ON departamento
 ( nome_departamento );
/*Criando chave alternativa*/

CREATE UNIQUE INDEX departamento_idx2
 ON departamento
 ( nome_departamento );

CREATE TABLE localizacoes_departamento (
                numero_departamento INTEGER NOT NULL,
                local VARCHAR(15) NOT NULL,
                CONSTRAINT pk_localizacoes_departamento PRIMARY KEY (numero_departamento, local)
);
COMMENT ON TABLE elmasri.localizacoes_departamento IS 'Tabela que armazena as localizações dos departamentos.';
COMMENT ON COLUMN elmasri.localizacoes_departamento.numero_departamento IS 'Número do departamento. É CHAVE PRIMARIA e CHAVE ESTRANGEIRA da departamento.';
COMMENT ON COLUMN elmasri.localizacoes_departamento.local IS 'Localização do departamento. Faz parte da CHAVE PRIMARIA desta tabela.';

CREATE TABLE projeto (
                numero_projeto INTEGER NOT NULL,
                nome_projeto VARCHAR(50) NOT NULL,
                local_projeto VARCHAR(50),
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT pk_projeto PRIMARY KEY (numero_projeto)
);
COMMENT ON TABLE elmasri.projeto IS 'Tabela que guarda os dados sobre os projetos dos departamentos.';
COMMENT ON COLUMN elmasri.projeto.numero_projeto IS 'Número do projeto. É a CHAVE PRIMARIA desta tabela.';
COMMENT ON COLUMN elmasri.projeto.nome_projeto IS 'Nome do projeto. Tem que ser único.';
COMMENT ON COLUMN elmasri.projeto.local_projeto IS 'Localização do projeto.';
COMMENT ON COLUMN elmasri.projeto.numero_departamento IS 'Número do departamento. É uma CHAVE ESTRANGEIRA para a tabela departamento.';

/*Criando chave alternativa*/
CREATE UNIQUE INDEX projeto_idx
 ON projeto
 ( nome_projeto );

CREATE TABLE trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto INTEGER NOT NULL,
                horas NUMERIC(3,1) NOT NULL,
                CONSTRAINT pk_trabalha_em PRIMARY KEY (cpf_funcionario, numero_projeto)
);
COMMENT ON TABLE elmasri.trabalha_em IS 'Tabela para guardar cada funcionários trabalham em cada projetos.';
COMMENT ON COLUMN elmasri.trabalha_em.cpf_funcionario IS 'CPF do funcionário. É a CHAVE PRIMARIA desta tabela e CHAVE ESTRANGEIRA da funcionário.';
COMMENT ON COLUMN elmasri.trabalha_em.numero_projeto IS 'Número do projeto. É a  CHAVE PRIMARIA desta tabela e CHAVE ESTRANGEIRA da projeto.';
COMMENT ON COLUMN elmasri.trabalha_em.horas IS 'Horas trabalhadas pelo funcionário no projeto.';


/*INSERINDO DADOS*/

INSERT INTO elmasri.funcionario VALUES
(88866555576, 'Jorge', 'E', 'Brito', '1937-11-10', 'Rua do Horto, 35, São Paulo, SP', 'M', 55000, 88866555576, 5),
(33344555587, 'Fernando', 'T', 'Wong', '1955-12-08', 'Rua da Lapa, 34, São Paulo, SP', 'M', 40000, 88866555576, 5),
(12345678966, 'João', 'B', 'Silva', '1965-01-09', 'Rua das Flores, 751, São Paulo, SP', 'M', 30000, 33344555587, 4),
(66688444476, 'Ronaldo', 'K', 'Lima', '1962-09-15', 'Rua Rebouças, 65, Piracicaba, SP', 'M', 38000, 33344555587, 4),
(45345345376, 'Joice', 'A', 'Leite', '1972-07-31', 'Av. Lucas Obes, 74, São Paulo, SP', 'F', 25000, 33344555587, 5),
(98765432168, 'Jennifer', 'S', 'Souza', '1941-06-20', 'Av. Arthur de Lima, 54, Santo André, SP', 'F', 43000, 88866555576, 5),
(99988777767, 'Alice', 'J', 'Zelaya', '1968-01-19', 'Rua Souza Lima, 35, Curitiba, PR', 'F', 25000, 98765432168, 4),
(98798798733, 'André', 'V', 'Pereira', '1969-03-29', 'Rua Timbira, 35, São Paulo, SP', 'M', 25000, 98765432168, 1);

/*preencher a tabela dependente*/
INSERT INTO elmasri.dependente VALUES
('Alicia', 33344555587, 'F', '1986-04-05', 'Filha'),
('Tiago', 33344555587, 'M', '1983-10-25', 'Filho'),
('Janaína', 33344555587, 'F', '1958-05-03', 'Esposa'),
('Antonio', 98765432168, 'M', '1942-02-28', 'Marido'),
('Michael', 12345678966, 'M', '1988-01-04', 'Filho'),
('Alicia', 12345678966, 'F', '1988-12-30', 'Filha'),
('Elizabeth', 12345678966, 'F', '1967-05-05', 'Esposa');


/*preencher tabela departamento*/
INSERT INTO elmasri.departamento VALUES
(5, 'Pesqusia', 33344555587, '1988-05-22'),
(4, 'Administração', 98765432168, '1995-01-01'),
(1, 'Matriz', 88866555576, '1981-06-19');

/*preencher tabela localizacoes_departamento*/
INSERT INTO elmasri.localizacoes_departamento VALUES
(1, 'São Paulo'),
(4, 'Mauá'),
(5, 'Santo André'),
(5, 'Itu'),
(5, 'São Paulo');

/* preencher tabela projeto*/
INSERT INTO elmasri.projeto VALUES
(1, 'Produto X', 'Santo André', 5),
(2, 'Produto Y', 'Itu', 5),
(3, 'Produto Z', 'São Paulo', 5),
(10, 'Informatização', 'Mauá', 4),
(20, 'Reorganiazãço', 'São Paulo', 1),
(30, 'Novos benefícios', 'Mauá', 4);

/*preencher tabela trabalha_em*/
INSERT INTO elmasri.trabalha_em VALUES
(12345678966, 1, 32.5),
(12345678966, 2, 7.5),
(66688444476, 3, 40),
(45345345376, 1, 20),
(45345345376, 2, 20),
(33344555587, 2, 10),
(33344555587, 3, 10),
(33344555587, 10, 10),
(33344555587, 20, 10),
(99988777767, 30, 30),
(99988777767, 10, 10),
(98798798733, 10, 35),
(98798798733, 30, 5),
(98765432168, 30, 20),
(98765432168, 20, 15),
(88866555576, 20, 0); 




/*Adicionando chave estrangeira nas tabelas */
ALTER TABLE departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/*DEFININDO INTEGRIDADES*/
ALTER TABLE elmasri.funcionario ADD CONSTRAINT CHK_funcionario CHECK
((sexo = 'F' OR sexo = 'M')AND salario >= 0);

ALTER TABLE elmasri.dependente ADD CONSTRAINT CHK_dependente CHECK
(sexo = 'F' OR sexo = 'M');

ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT CHK_trabalha_em CHECK 
(horas >= 0);