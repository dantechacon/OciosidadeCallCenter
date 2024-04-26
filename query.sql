--Explorando a base de jobs finalizados. Basicamente, estamos olhando para a produtividade de operadores, ou seja, a quantidade de atendimentos que eles realizam num determinado período de tempo.
WITH FinishedJobs AS (
  SELECT
    actor_affiliation AS BPO,
    actor_squad AS squad,
    agent,
    local_start_date AS date,
    activity_type,
    COUNT(*) AS total_finished
  FROM `dataset.tempo_atividades`
  WHERE 
    local_start_date >= '2024-01-01'
    AND (actor_affiliation = 'operação1' OR actor_affiliation = 'operação2')
    AND status = 'finished'
    AND actor_squad = 'cobrança'
    AND activity_type IN ("chat", "phone", "email")
  GROUP BY
    actor_affiliation,
    actor_squad,
    agent,
    local_start_date,
    activity_type
),

--Explorando a base de disponibilidade. Preparando o campo de duração de disponibilidade em status de performing_jobs. Esse status determina operadores que estão disponíveis na ferramenta de atendimento e aptos a atender.

AgentMetrics AS (
  SELECT
    date,
    affiliation AS BPO,
    squad,
    agent,
    SUM(duration)/3600 AS disponibilidade_hora
  FROM `dataset.metricas_operadores`
  WHERE 
    date >= '2024-01-01'
    AND activity_type IN ("chat", "phone", "email")
    AND squad = 'cobrança'
    AND status = 'performing_jobs'
    AND affiliation IN ("operação1", "operação2")
  GROUP BY
    date,
    affiliation,
    squad,
    agent
)

--Definindo o novo campo de jobs por disponibilidade. Perceba que o campo cruza duas informações: quanto tempo a pessoa operadora ficou ativa na ferramenta e, nesse período, quantos atendimentos ela realizou.

SELECT
  job.BPO AS BPO,
  job.squad AS squad,
  job.agent AS agent,
  job.date AS date,
  job.activity_type AS activity_type,
  job.total_finished AS total_finished,
  COALESCE(metrics.disponibilidade_hora, 0) AS disponibilidade_hora,
  CASE
    WHEN metrics.disponibilidade_hora = 0 THEN 0
    ELSE job.total_finished / metrics.disponibilidade_hora
  END AS job_por_disponibilidade
FROM FinishedJobs AS job
LEFT JOIN AgentMetrics AS metrics
ON
  job.date = metrics.date
  AND job.BPO = metrics.BPO
  AND job.squad = metrics.squad
  AND job.agent = metrics.agent;
