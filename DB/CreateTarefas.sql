CREATE TABLE Tarefas (
    Id INT IDENTITY(1,1) NOT NULL,
    Titulo NVARCHAR(200) NOT NULL,
    Descricao NVARCHAR(1000) NULL,
    Prioridade INT NOT NULL,
    Status NVARCHAR(20) NOT NULL,
    DataCriacao DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    DataConclusao DATETIME2 NULL,

    CONSTRAINT PK_Tarefas PRIMARY KEY (Id)
);


CREATE INDEX idx_TarefasStatus
ON Tarefas (Status);

CREATE INDEX idx_TarefasDataConclusao
ON Tarefas (DataConclusao);