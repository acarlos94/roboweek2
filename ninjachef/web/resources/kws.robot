***Settings***
Documentation       Aqui teremos todas as palavras chaves de automação dos comportamentos.

***Keywords***
Dado que acesso a pagina principal
    Go To    ${base_url} 

Quando submeto o meu email "${email}" 
    Input Text      ${CAMPO_EMAIL}    ${email}
    Click Element   ${BOTAO_ENTRAR}

Então devo ser autenticado
    Wait Until Page Contains Element    ${DIV_DASH} 

Então devo ver a mensagem "${expect_message}"
    Wait Until Element Contains         ${DIV_ALERT}     ${expect_message}

# Cadastro de produto

Dado que "${produto}" é um dos meus pratos
    Set Test Variable                   ${produto}

Quando faço o cadastro desse item
    Wait Until Element Is Visible       ${BOTAO_ADD}       5                   
    Click Element                       ${BOTAO_ADD}

    Choose File         ${CAMPO_FOTO}            ${EXECDIR}/resources/images/${produto['img']}

    Input Text          ${CAMPO_NOME}            ${produto['nome']}
    Input Text          ${CAMPO_TIPO}            ${produto['tipo']}
    Input Text          ${CAMPO_PRECO}           ${produto['preco']}
    Click Element       ${BOTAO_CADASTRAR}

Então devo ver esse prato no meu dashboard
    Wait Until Element Contains         ${LISTA_PRODUTOS}        ${produto['nome']}

# Kws do cenario receber novo pedido

Dado que "${email_cozinheiro}" é a minha conta de cozinheiro
    Set Test Variable       ${email_cozinheiro}

    ${token_cozinheiro}=    Get Api Token       ${email_cozinheiro}
    Set Test Variable       ${token_cozinheiro}

E "${email_cliente}" é o email do meu cliente
    Set Test Variable       ${email_cliente}

    ${token_cliente}=     Get Api Token         ${email_cliente}      
    Set Test Variable       ${token_cliente}

E que "${produto}" está cadastrado no meu dashboard
    Set Test Variable       ${produto}

    &{payload}=         Create Dictionary       name=${produto}     plate=Tipo      price=30.00

    ${image_file}=      Get Binary File         ${EXECDIR}/resources/images/AssadoLentilha.jpg
    &{files}=           Create Dictionary       thumbnail=${image_file}

    &{headers}=         Create Dictionary       user_id=${token_cozinheiro}

    Create Session      api             ${api_url}
    ${resp}=            Post Request    api      /products      files=${files}      data=${payload}       headers=${headers}
    Status Should Be    200             ${resp}

    ${produto_id}       Convert To String      ${resp.json()['_id']}
    Set Test Variable       ${produto_id}

    Go to               ${base_url} 
    Input Text          ${CAMPO_EMAIL}        ${email_cozinheiro}
    Click Element       ${BOTAO_ENTRAR}
    Wait Until Page Contains Element          ${DIV_DASH}

Quando o cliente solicita o preparo desse prato
    &{headers}=         Create Dictionary       Content-Type=application/json       user_id=${token_cliente}
    &{payload}=         Create Dictionary       payment=Dinheiro

    Create Session      api             ${api_url}
    ${resp}=            Post Request    api      /products/${produto_id}/orders      data=${payload}       headers=${headers}
    Status Should Be    200             ${resp}

Então devo receber uma notificação de pedido desse produto
    ${mensagem_esperada}        Convert To String       ${email_cliente} está solicitando o preparo do seguinte prato: ${produto}.
    Wait Until Page Contains    ${mensagem_esperada}    5

E posso aceitar ou rejeitar esse pedido
    Wait Until Page Contains    ACEITAR     5
    Wait Until Page Contains    REJEITAR    5