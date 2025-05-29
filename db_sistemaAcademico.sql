-- Remove o banco, se existir
DROP DATABASE IF EXISTS sistemaacademico;

-- Cria o banco e seleciona ele
CREATE DATABASE sistemaacademico;
USE sistemaacademico;

-- Criação das tabelas
CREATE TABLE aluno (
    rgm INT PRIMARY KEY,
    nome VARCHAR(50),
    dt_nasc DATE,
    telefone VARCHAR(20)
);

CREATE TABLE disciplina (
    codigo INT PRIMARY KEY,
    nome VARCHAR(50),
    num_creditos INT
);

CREATE TABLE cursa (
    aluno INT,
    disciplina INT,
    PRIMARY KEY (aluno, disciplina),
    FOREIGN KEY (aluno) REFERENCES aluno(rgm),
    FOREIGN KEY (disciplina) REFERENCES disciplina(codigo)
);

-- Inserção de dados
INSERT INTO aluno VALUES
(1, 'Pedro', '1980-09-23', '(11)4647-9876'),
(2, 'Marcos', '1984-10-03', '(12)3875-9876'),
(3, 'Rita', '1999-08-18', '(11)3257-9456'),
(4, 'Carla', '1998-08-10', '(11)3358-9557'),
(5, 'Roberto', '2019-07-18', '(12)3458-8466');

INSERT INTO disciplina VALUES
(1, 'Banco de Dados', 64),
(2, 'Técnicas de Programação', 18),
(3, 'Análise OO', 32);

INSERT INTO cursa VALUES
(1, 1),
(2, 1),
(3, 2);

-- Procedure: Selecionar todas as disciplinas
DROP PROCEDURE IF EXISTS SelectDisciplinas2;
DELIMITER //
CREATE PROCEDURE SelectDisciplinas2()
BEGIN
    SELECT * FROM disciplina;
END;
//
DELIMITER ;

-- Procedure: Inserir disciplina
DROP PROCEDURE IF EXISTS insertDisciplinas;
DELIMITER //
CREATE PROCEDURE insertDisciplinas(IN id INT, IN disc VARCHAR(50), IN numCred INT)
BEGIN
    INSERT INTO disciplina(codigo, nome, num_creditos)
    VALUES(id, disc, numCred);
END;
//
DELIMITER ;

-- Procedure: Consultar aluno por RGM
DROP PROCEDURE IF EXISTS Consulta_Aluno_porRGM;
DELIMITER //
CREATE PROCEDURE Consulta_Aluno_porRGM(IN parametro INT)
BEGIN
    DECLARE nome_aluno VARCHAR(55);
    SELECT nome INTO nome_aluno FROM aluno WHERE rgm = parametro;
    SELECT nome_aluno AS nome_do_aluno;
END;
//
DELIMITER ;

-- Procedure: Usando IF para escolher tabela
DROP PROCEDURE IF EXISTS ConsultaDados;
DELIMITER //
CREATE PROCEDURE ConsultaDados(IN tabela INT)
BEGIN
    IF tabela = 1 THEN
        SELECT * FROM disciplina;
    ELSE
        SELECT * FROM aluno;
    END IF;
END;
//
DELIMITER ;

-- Procedure: Consulta com LIKE
DROP PROCEDURE IF EXISTS ConsultaNomeIntervalo;
DELIMITER //
CREATE PROCEDURE ConsultaNomeIntervalo(IN parte_nome VARCHAR(55))
BEGIN
    SELECT * FROM disciplina WHERE nome LIKE CONCAT('%', parte_nome, '%');
END;
//
DELIMITER ;

-- Procedure com IN e OUT
DROP PROCEDURE IF EXISTS ConsultaTotalDisciplinas;
DELIMITER //
CREATE PROCEDURE ConsultaTotalDisciplinas(IN parte_nome VARCHAR(55), OUT total INT)
BEGIN
    SELECT COUNT(*) INTO total
    FROM disciplina
    WHERE nome LIKE CONCAT('%', parte_nome, '%');
END;
//
DELIMITER ;

-- Testes (opcional - pode comentar ao rodar tudo junto):
CALL SelectDisciplinas2();
CALL insertDisciplinas(4, 'Sistema de Informação', 60);
CALL Consulta_Aluno_porRGM(2);
CALL ConsultaDados(2);
CALL ConsultaNomeIntervalo('dados');
CALL ConsultaTotalDisciplinas('dado', @total);
SELECT @total;
