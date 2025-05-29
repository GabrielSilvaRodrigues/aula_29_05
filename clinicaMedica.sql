-- 1. Criação do banco de dados e seleção
CREATE DATABASE ClinicaMedica;
USE ClinicaMedica;

-- 2. Criação das tabelas e relacionamentos
CREATE TABLE medico (
    crm VARCHAR(10),
    nome VARCHAR(100),
    PRIMARY KEY (crm)
);

CREATE TABLE paciente (
    codigo INT,
    nome VARCHAR(100),
    PRIMARY KEY (codigo)
);

CREATE TABLE especialidade (
    codigo INT,
    nome VARCHAR(50),
    PRIMARY KEY (codigo)
);

CREATE TABLE convenio (
    codigo INT,
    nome VARCHAR(50),
    PRIMARY KEY (codigo)
);

CREATE TABLE exame (
    codigo INT,
    descricao VARCHAR(50),
    valor NUMERIC(10,2),
    PRIMARY KEY (codigo)
);

CREATE TABLE atende (
    codigo INT,
    data_consulta DATE,
    diagnostico VARCHAR(200),
    crm_medico VARCHAR(10),
    cod_paciente INT,
    cod_especialidade INT,
    cod_convenio INT,
    PRIMARY KEY (codigo),
    FOREIGN KEY (crm_medico) REFERENCES medico(crm),
    FOREIGN KEY (cod_paciente) REFERENCES paciente(codigo),
    FOREIGN KEY (cod_especialidade) REFERENCES especialidade(codigo),
    FOREIGN KEY (cod_convenio) REFERENCES convenio(codigo)
);

CREATE TABLE contem (
    cod_atende INT,
    cod_exame INT,
    PRIMARY KEY (cod_atende, cod_exame),
    FOREIGN KEY (cod_atende) REFERENCES atende(codigo),
    FOREIGN KEY (cod_exame) REFERENCES exame(codigo)
);

-- 3. Inclusão de dados nas tabelas
INSERT INTO medico (crm, nome) VALUES
('123-sp', 'Dra Maria Cristina'),
('948-mg', 'Dr Eduardo'),
('947-sp', 'Dr José Antonio'),
('944-MG', 'Dra Suzi Antonia'),
('144-MG', 'Dra Claudia'),
('124-SP', 'Dra Maria Luiza'),
('344-MG', 'Dr Victor');

INSERT INTO paciente (codigo, nome) VALUES
(1, 'Maria'),
(2, 'Juliano'),
(3, 'Clara');

INSERT INTO especialidade (codigo, nome) VALUES
(10, 'Dermatologia'),
(20, 'Clínica Geral'),
(30, 'Oftalmologia');

INSERT INTO convenio (codigo, nome) VALUES
(100, 'Amil'),
(200, 'Saúde Bradesco'),
(300, 'Unimed');

INSERT INTO exame (codigo, descricao, valor) VALUES
(1, 'Ultrassom', 25.66),
(2, 'Fundo de olho', 50),
(3, 'Glicemia', 30.50);

INSERT INTO atende (codigo, data_consulta, diagnostico, crm_medico, cod_paciente, cod_especialidade, cod_convenio) VALUES
(10, '2014-04-15', 'Resfriado', '123-sp', 3, 20, 100),
(11, '2014-03-25', 'Rotina', '948-mg', 2, 30, 200),
(12, '2014-04-02', 'Alergia', '947-sp', 1, 10, 300),
(13, '2014-05-02', 'Alergia', '947-sp', 1, 10, 300);

INSERT INTO contem (cod_atende, cod_exame) VALUES
(10, 1),
(10, 3),
(11, 2);

-- 4. Consultas para verificar os dados
SELECT * FROM medico;
SELECT * FROM paciente;
SELECT * FROM especialidade;
SELECT * FROM convenio;
SELECT * FROM exame;
SELECT * FROM atende;
SELECT * FROM contem;

-- 5. Atualizações e modificações
UPDATE exame SET valor = 200.00 WHERE codigo = 1;

UPDATE exame SET valor = valor * 1.15 WHERE valor < 100;

-- 6. Consultas específicas
SELECT paciente.nome AS nome_paciente, medico.nome AS nome_medico
FROM paciente
INNER JOIN atende ON paciente.codigo = atende.cod_paciente
INNER JOIN medico ON atende.crm_medico = medico.crm
WHERE MONTH(atende.data_consulta) = 5;

SELECT convenio.nome, COUNT(atende.cod_convenio) AS quantidade_consultas
FROM convenio
INNER JOIN atende ON convenio.codigo = atende.cod_convenio
WHERE atende.data_consulta IN ('2014-04-01', '2014-04-08', '2014-04-15', '2014-04-22')
GROUP BY convenio.nome;

SELECT especialidade.nome, COUNT(atende.cod_especialidade) AS quantidade_atendimentos
FROM especialidade
INNER JOIN atende ON especialidade.codigo = atende.cod_especialidade
WHERE atende.data_consulta BETWEEN '2014-01-01' AND '2014-06-30'
GROUP BY especialidade.nome
ORDER BY especialidade.nome DESC;

SELECT exame.descricao
FROM exame
INNER JOIN contem ON exame.codigo = contem.cod_exame
INNER JOIN atende ON contem.cod_atende = atende.codigo
INNER JOIN medico ON atende.crm_medico = medico.crm
WHERE medico.nome = 'Dr Eduardo'
AND atende.data_consulta BETWEEN '2014-03-15' AND '2014-03-30';

-- 7. Criação de views
CREATE VIEW vsConsultasMaio AS
SELECT paciente.nome AS nome_paciente, medico.nome AS nome_medico
FROM paciente
INNER JOIN atende ON paciente.codigo = atende.cod_paciente
INNER JOIN medico ON atende.crm_medico = medico.crm
WHERE MONTH(atende.data_consulta) = 5;

SELECT * FROM vsConsultasMaio;

-- 8. Criação de procedimentos armazenados
DELIMITER //
CREATE PROCEDURE spConsultasPorMes(IN pmes INT)
BEGIN
    SELECT paciente.nome AS nome_paciente, medico.nome AS nome_medico
    FROM paciente
    INNER JOIN atende ON paciente.codigo = atende.cod_paciente
    INNER JOIN medico ON atende.crm_medico = medico.crm
    WHERE MONTH(atende.data_consulta) = pmes;
END //
DELIMITER ;

CALL spConsultasPorMes(5);

-- 9. Criação de funções
DELIMITER //
CREATE FUNCTION fQuantidadeConsultasPorPeriodo(data_inicio DATE, data_fim DATE) RETURNS INT
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM atende
    WHERE data_consulta BETWEEN data_inicio AND data_fim;
    RETURN total;
END //
DELIMITER ;

SELECT fQuantidadeConsultasPorPeriodo('2014-01-01', '2014-06-30');

-- 10. Backup de dados
CREATE TABLE paciente_backup LIKE paciente;
INSERT INTO paciente_backup SELECT * FROM paciente;
SELECT * FROM paciente_backup;
