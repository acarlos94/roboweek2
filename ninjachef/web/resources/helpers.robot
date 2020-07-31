***Settings***
Documentation           Aqui teremos palavras chaves de apoio

***Keywords***
Login Session
    [Arguments]     ${email}

    base.Open Session

    Go to               ${base_url} 

    Input Text          ${CAMPO_EMAIL}        ${email}
    Click Element       ${BOTAO_ENTRAR}

    Wait Until Page Contains Element          ${DIV_DASH}

Get Api Token
    [Arguments]         ${email_param}

    &{headers}=         Create Dictionary       Content-Type=application/json
    &{payload}=         Create Dictionary       email=${email_param}

    Create Session      api             ${api_url}
    ${resp}=            Post Request    api      /sessions      data=${payload}       headers=${headers}
    Status Should Be    200             ${resp}

    ${token}     Convert To String      ${resp.json()['_id']}
    [Return]       ${token}
