# Problema do negócio

Foi identificado um alto índice de funcionários que ficam disponíveis na ferramenta de atendimento de uma empresa, mas produzem muito pouco, ou seja, ficam grande parte do turno ociosos, fazendo o mínimo de atendimentos. Para fiscalizar e trackear esse operadores, surgiu o índice de ociosidade.

# Produtividade (atendimentos feitos) por tempo disponível

Manipulação de datasets para gerar a visão de ociosidade, que identifica operadores com alto tempo de disponibilidade na ferramenta, mas baixa produtividade.
Após realizada a manipulação dos BDs, o índice de ociosidade será definido por meio de uma definição de scores dos operadores, identificando com score 1 os operadores com o melhor indicador de atendimentos por disponibilidade, e com score 5 os operadores com o pior indicador. Feito isso, será gerada uma média ponderada, após definição de pesos para cada score.

# Índice de Ociosidade

Essa média será utilizada para definir o índice e rankear operadores que ficam mais ociosos na ferramenta. Se há um alto índice de tempo disponível, mas um baixo índice de produtividade, entendemos que o operador ficou ocioso na ferramenta. Sendo assim, o trabalho com ele será realizado de forma a diminuir essa ociosidade, ou seja, aumentar a produtividade dentre os que mais ficam disponíveis.
