
/*questão 1*/
SELECT numero_departamento, round(avg(salario)) AS media_salarial 
FROM funcionario 
GROUP BY numero_departamento;

/*questão 2*/
SELECT sexo, avg(salario) AS media_salarial 
FROM funcionario 
GROUP BY sexo;

/*questao 3*/
SELECT departamento.nome_departamento,CONCAT(primeiro_nome,' ',
nome_meio ,' ',
ultimo_nome) AS nome_funcionario,
data_nascimento,
age(data_nascimento, current_date) AS idade,
salario
FROM funcionario
INNER JOIN departamento
ON funcionario.numero_departamento = departamento.numero_departamento;

/*questao 4*/
SELECT CONCAT(
primeiro_nome,' ',
nome_meio,' ',
ultimo_nome) AS Nome,age(data_nascimento, current_date) AS idade,
salario,
CASE
  WHEN salario < 35000 then salario * 1.20 
  WHEN salario > 35000 then salario * 1.15
END "Reajuste"
FROM funcionario;

/*questao 5*/
SELECT nome_departamento,
CASE
WHEN funcionario.cpf = departamento.cpf_gerente then 'gerente'
ELSE 'funcionario'
END as cargo,
CONCAT(primeiro_nome,' ',
nome_meio,' ',
ultimo_nome) AS nome,
salario
FROM departamento, funcionario
WHERE departamento.numero_departamento = funcionario.numero_departamento
ORDER BY nome_departamento,
salario DESC;

/*questao 6*/
SELECT 
primeiro_nome AS nome_funcionario,
numero_departamento,
CONCAT(
dependente.nome_dependente,' ',
nome_meio,' ',
ultimo_nome) AS nome_dependente,
age(dependente.data_nascimento, current_date) AS idade_dependente,
CASE
  WHEN dependente.sexo = 'M' then 'masculino'
ELSE 'feminino'end "sexo_dependente"
FROM funcionario
INNER JOIN dependente
ON funcionario.cpf = dependente.cpf_funcionario;


/*questão 7*/
SELECT CONCAT(primeiro_nome,' ',
nome_meio,' ',
ultimo_nome) AS nome_completo,
numero_departamento,
salario
FROM funcionario
EXCEPT
SELECT CONCAT(primeiro_nome,' ',
nome_meio,' ',
ultimo_nome) AS nome_completo,
numero_departamento,
salario
FROM funcionario
INNER JOIN dependente ON(funcionario.cpf = dependente.cpf_funcionario);


/*questão 8*/
SELECT numero_departamento,
numero_projeto,
CONCAT(funcionario.primeiro_nome,' ',
funcionario.nome_meio,' ',
funcionario.ultimo_nome) AS nome_completo,
horas
FROM funcionario
INNER JOIN trabalha_em on funcionario.cpf = trabalha_em.cpf_funcionario;

/*questão 9*/
SELECT nome_departamento,
nome_projeto,
SUM(horas) AS total_horas
FROM departamento, projeto, trabalha_em
WHERE departamento.numero_departamento = projeto.numero_departamento
AND projeto.numero_projeto = trabalha_em.numero_projeto
GROUP BY nome_departamento, nome_projeto
ORDER BY nome_departamento;

/*questão 10*/
SELECT numero_departamento,
avg(salario) as media_salarial
FROM funcionario 
GROUP BY numero_departamento;

/*questão 11*/
SELECT CONCAT(primeiro_nome, ' ', 
nome_meio, ' ', 
ultimo_nome) 
AS nome_completo,
nome_projeto,
horas*50 AS salario_50_por_h
FROM funcionario, projeto, trabalha_em 
WHERE projeto.numero_projeto = trabalha_em.numero_projeto
AND funcionario.cpf = trabalha_em.cpf_funcionario 
ORDER BY nome_projeto;

/*questão 12*/
SELECT DISTINCT nome_departamento, nome_projeto, primeiro_nome, horas
FROM trabalha_em
INNER JOIN funcionario
ON funcionario.cpf = trabalha_em.cpf_funcionario
INNER JOIN projeto
ON projeto.numero_projeto = trabalha_em.numero_projeto
INNER JOIN departamento
ON departamento.numero_departamento = projeto.numero_departamento
WHERE horas = 0;

/*questão 13*/
SELECT CONCAT(primeiro_nome,' ',
nome_meio,' ',
ultimo_nome), funcionario.sexo,
age(data_nascimento,current_date) AS idade
FROM funcionario
UNION
SELECT nome_dependente,
dependente.sexo,
age(data_nascimento,current_date) AS idade
FROM dependente
ORDER BY idade 
DESC;

/*questão 14*/
SELECT nome_departamento,
COUNT(cpf) AS funcionario
FROM departamento
INNER JOIN funcionario ON (departamento.numero_departamento = funcionario.numero_departamento)
GROUP BY nome_departamento;

/*questão 15*/
SELECT CONCAT(primeiro_nome,' ',
nome_meio,' ',
ultimo_nome) AS nome_completo,
nome_departamento, nome_projeto
FROM projeto
INNER JOIN departamento ON (projeto.numero_departamento = departamento.numero_departamento)
INNER JOIN funcionario ON (projeto.numero_departamento = funcionario.numero_departamento)
ORDER BY nome_departamento, nome_projeto;