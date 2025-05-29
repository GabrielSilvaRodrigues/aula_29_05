CREATE DATABASE delimeter;
USE delimeter;
CREATE TABLE usuario (
    id_usuario BIGINT PRIMARY KEY AUTO_INCREMENT,
    nome_usuario VARCHAR(100) NOT NULL,
    email_usuario VARCHAR(100) UNIQUE,
    senha_usuario VARCHAR(100) NOT NULL
);

CREATE TABLE endereco_usuario (
    id_endereco BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_usuario BIGINT NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE telefone_usuario (
    id_telefone BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_usuario BIGINT NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE medico (
    id_medico BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_usuario BIGINT NOT NULL,
    crm_medico VARCHAR(50),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE nutricionista (
    id_nutricionista BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_usuario BIGINT NOT NULL,
    crm_nutricionista VARCHAR(50),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE paciente (
    id_paciente BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_usuario BIGINT NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    nis VARCHAR(20) UNIQUE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE dados_antropometricos (
    id_medida BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_paciente BIGINT NOT NULL,
    sexo_paciente INT,
    altura_paciente FLOAT,
    peso_paciente FLOAT,
    status_paciente INT,
    data_medida DATE,
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente)
);

CREATE TABLE dieta (
    id_dieta BIGINT PRIMARY KEY AUTO_INCREMENT,
    data_inicio_dieta DATE,
    data_termino_dieta DATE,
    descricao_dieta VARCHAR(255)
);

CREATE TABLE alimento (
    id_alimento BIGINT PRIMARY KEY AUTO_INCREMENT,
    descricao_alimento VARCHAR(255),
    dados_nutricionais VARCHAR(255)
);

CREATE TABLE diario_de_alimentos (
    id_diario BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_paciente BIGINT,
    data_diario DATE,
    descricao_diario VARCHAR(255),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente)
);

CREATE TABLE receita (
    id_receita BIGINT PRIMARY KEY AUTO_INCREMENT,
    data_inicio_receita DATE,
    data_termino_receita DATE,
    descricao_receita VARCHAR(255)
);

CREATE TABLE consulta (
    id_consulta BIGINT PRIMARY KEY AUTO_INCREMENT,
    data_consulta DATE
);

CREATE TABLE historico_clinico (
    id_historico_clinico BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_paciente BIGINT,
    id_receita BIGINT,
    id_dieta BIGINT,
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_receita) REFERENCES receita(id_receita),
    FOREIGN KEY (id_dieta) REFERENCES dieta(id_dieta)
);

CREATE TABLE relacao_diario_alimento (
    id_alimento BIGINT,
    id_diario BIGINT,
    PRIMARY KEY (id_alimento, id_diario),
    FOREIGN KEY (id_alimento) REFERENCES alimento(id_alimento),
    FOREIGN KEY (id_diario) REFERENCES diario_de_alimentos(id_diario)
);

CREATE TABLE relacao_alimento_dieta (
    id_alimento BIGINT,
    id_dieta BIGINT,
    PRIMARY KEY (id_alimento, id_dieta),
    FOREIGN KEY (id_alimento) REFERENCES alimento(id_alimento),
    FOREIGN KEY (id_dieta) REFERENCES dieta(id_dieta)
);

CREATE TABLE relacao_nutricionista_dieta (
    id_dieta BIGINT,
    id_nutricionista BIGINT,
    PRIMARY KEY (id_dieta, id_nutricionista),
    FOREIGN KEY (id_dieta) REFERENCES dieta(id_dieta),
    FOREIGN KEY (id_nutricionista) REFERENCES nutricionista(id_nutricionista)
);

CREATE TABLE valida_medidas_nutricionista (
    id_medida BIGINT,
    id_nutricionista BIGINT,
    PRIMARY KEY (id_medida, id_nutricionista),
    FOREIGN KEY (id_medida) REFERENCES dados_antropometricos(id_medida),
    FOREIGN KEY (id_nutricionista) REFERENCES nutricionista(id_nutricionista)
);

CREATE TABLE relacao_paciente_receita (
    id_paciente BIGINT,
    id_receita BIGINT,
    PRIMARY KEY (id_paciente, id_receita),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_receita) REFERENCES receita(id_receita)
);

CREATE TABLE relacao_nutricionista_receita (
    id_receita BIGINT,
    id_nutricionista BIGINT,
    PRIMARY KEY (id_receita, id_nutricionista),
    FOREIGN KEY (id_receita) REFERENCES receita(id_receita),
    FOREIGN KEY (id_nutricionista) REFERENCES nutricionista(id_nutricionista)
);

CREATE TABLE relacao_paciente_dieta (
    id_dieta BIGINT,
    id_paciente BIGINT,
    PRIMARY KEY (id_dieta, id_paciente),
    FOREIGN KEY (id_dieta) REFERENCES dieta(id_dieta),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente)
);

CREATE TABLE valida_dieta (
    id_medico BIGINT,
    id_dieta BIGINT,
    PRIMARY KEY (id_medico, id_dieta),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico),
    FOREIGN KEY (id_dieta) REFERENCES dieta(id_dieta)
);

CREATE TABLE valida_receita (
    id_receita BIGINT,
    id_medico BIGINT,
    PRIMARY KEY (id_receita, id_medico),
    FOREIGN KEY (id_receita) REFERENCES receita(id_receita),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico)
);

CREATE TABLE valida_dados_antropometricos (
    id_medida BIGINT,
    id_medico BIGINT,
    PRIMARY KEY (id_medida, id_medico),
    FOREIGN KEY (id_medida) REFERENCES dados_antropometricos(id_medida),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico)
);

CREATE TABLE valida_diario (
    id_nutricionista BIGINT,
    id_diario BIGINT,
    PRIMARY KEY (id_nutricionista, id_diario),
    FOREIGN KEY (id_nutricionista) REFERENCES nutricionista(id_nutricionista),
    FOREIGN KEY (id_diario) REFERENCES diario_de_alimentos(id_diario)
);

CREATE TABLE relacao_paciente_consulta (
    id_consulta BIGINT,
    id_paciente BIGINT,
    PRIMARY KEY (id_consulta, id_paciente),
    FOREIGN KEY (id_consulta) REFERENCES consulta(id_consulta),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente)
);

CREATE TABLE relacao_consulta_nutricionista (
    id_consulta BIGINT,
    id_nutricionista BIGINT,
    PRIMARY KEY (id_consulta, id_nutricionista),
    FOREIGN KEY (id_consulta) REFERENCES consulta(id_consulta),
    FOREIGN KEY (id_nutricionista) REFERENCES nutricionista(id_nutricionista)
);

CREATE TABLE relacao_consulta_medico (
    id_consulta BIGINT,
    id_medico BIGINT,
    PRIMARY KEY (id_consulta, id_medico),
    FOREIGN KEY (id_consulta) REFERENCES consulta(id_consulta),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico)
);

DELIMITER //

CREATE TRIGGER trigger_historico_dieta
AFTER INSERT ON relacao_paciente_dieta
FOR EACH ROW
BEGIN
    INSERT INTO historico_clinico (id_paciente, id_dieta)
    VALUES (NEW.id_paciente, NEW.id_dieta);
END;
//

CREATE TRIGGER trigger_historico_receita
AFTER INSERT ON relacao_paciente_receita
FOR EACH ROW
BEGIN
    INSERT INTO historico_clinico (id_paciente, id_receita)
    VALUES (NEW.id_paciente, NEW.id_receita);
END;
//

DELIMITER ;