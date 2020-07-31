***Settings***
Documentation       Suite dos testes de cadastro

Resource        ../resources/base.robot

Test Setup      Open Session
Test Teardown       Close Session

***Test Cases***
Cadastro simples
    Dado que acesso a pagina principal
    Quando submeto o meu email "antonio@gmail.com"
    Então devo ser autenticado

Email incorreto
    Dado que acesso a pagina principal
    Quando submeto o meu email "antonio&yahoo.com" 
    Então devo ver a mensagem "Oops. Informe um email válido!"

Email não informado
    Dado que acesso a pagina principal
    Quando submeto o meu email "${EMPTY}" 
    Então devo ver a mensagem "Oops. Informe um email válido!"