-- Remove o banco, se existir
DROP DATABASE IF EXISTS SistemaAcademico;

-- Cria o banco e seleciona ele
CREATE DATABASE SistemaAcademico;
USE SistemaAcademico;

-- Tabela aluno
CREATE TABLE aluno (
    rgm INT PRIMARY KEY,
    nome VARCHAR(50),
    dt_nasc DATE,
    telefone VARCHAR(20)
);

-- Tabela disciplina
CREATE TABLE disciplina (
    codigo INT PRIMARY KEY,
    nome VARCHAR(50),
    num_creditos INT
);

-- Tabela cursa (relacionamento N:N entre aluno e disciplina)
CREATE TABLE cursa (
    aluno INT,
    disciplina INT,
    PRIMARY KEY (aluno, disciplina),
    FOREIGN KEY (aluno) REFERENCES aluno(rgm),
    FOREIGN KEY (disciplina) REFERENCES disciplina(codigo)
);

-- Inserção de alunos
INSERT INTO aluno (rgm, nome, dt_nasc, telefone) VALUES 
(1, 'Pedro', '1980-09-23', '(11)4647-9876'),
(2, 'Marcos', '1984-10-03', '(12)3875-9876'),
(3, 'Rita', '1999-08-18', '(11)3257-9456'),
(4, 'Carla', '1998-08-10', '(11)3358-9557'),
(5, 'Roberto', '2019-07-18', '(12)3458-8466');

-- Inserção de disciplinas
INSERT INTO disciplina (codigo, nome, num_creditos) VALUES
(1, 'Banco de Dados', 64),
(2, 'Técnicas de Programação', 18),
(3, 'Análise OO', 32);

-- Inserção de dados na tabela cursa
INSERT INTO cursa (aluno, disciplina) VALUES
(1, 1),
(2, 1),
(3, 2);

-- Criação de procedure para selecionar todas as disciplinas
DELIMITER //
CREATE PROCEDURE SelectDisciplinas()
BEGIN
    SELECT * FROM disciplina;
END;
//
DELIMITER ;

-- Chamada do procedure
CALL SelectDisciplinas();

-- Procedure para inserir uma nova disciplina
DELIMITER //
CREATE PROCEDURE InsertDisciplinas (
    IN pcodigo INT,
    IN pnome VARCHAR(50),
    IN pnum_creditos INT
)
BEGIN
    INSERT INTO disciplina(codigo, nome, num_creditos)
    VALUES(pcodigo, pnome, pnum_creditos);
END;
//
DELIMITER ;

-- Chamadas para inserir disciplinas usando procedure
CALL InsertDisciplinas(4, 'Sistema de Informação', 60);
CALL InsertDisciplinas(5, 'Banco de dados', 60);
CALL InsertDisciplinas(6, 'Laboratório de banco de dados', 40);

-- Consulta geral das disciplinas
SELECT * FROM disciplina;

-- Procedure para consultar aluno pelo RGM
DELIMITER //
CREATE PROCEDURE Consulta_Aluno_porRA(IN parametro INT)
BEGIN
    DECLARE nome_aluno VARCHAR(55);
    SELECT nome INTO nome_aluno FROM aluno WHERE rgm = parametro;
    SELECT nome_aluno;
END;
//
DELIMITER ;

-- Chamada da consulta de aluno
CALL Consulta_Aluno_porRA(2);

-- Procedure que seleciona disciplinas ou alunos, conforme parâmetro
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

-- Chamada do procedure condicional
CALL ConsultaDados(1);

-- Procedure para buscar nome com parte do texto
DELIMITER //
CREATE PROCEDURE ConsultaNomeIntervalo(IN parte_nome VARCHAR(55))
BEGIN
    SELECT * FROM disciplina 
    WHERE nome LIKE CONCAT('%', parte_nome, '%');
END;
//
DELIMITER ;

-- Chamadas de exemplo
CALL ConsultaNomeIntervalo('dado');
CALL ConsultaNomeIntervalo('OO');

-- Procedure com parâmetro de saída (contagem de disciplinas)
DELIMITER //
CREATE PROCEDURE ConsultaTotalDisciplinas(
    IN parte_nome VARCHAR(55), 
    OUT total INT
)
BEGIN
    SELECT COUNT(*) INTO total 
    FROM disciplina 
    WHERE nome LIKE CONCAT('%', parte_nome, '%');
END;
//
DELIMITER ;

-- Chamando e visualizando o total de disciplinas
CALL ConsultaTotalDisciplinas('dado', @total);
SELECT @total;

-- Função para contar disciplinas com parte do nome
DELIMITER //
CREATE FUNCTION ConsultaTotalDisciplinasFunc(parte_nome VARCHAR(55)) 
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total 
    FROM disciplina 
    WHERE nome LIKE CONCAT('%', parte_nome, '%');
    RETURN total;
END;
//
DELIMITER ;

-- Chamada da função
SELECT ConsultaTotalDisciplinasFunc('dado');