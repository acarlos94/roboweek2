***Settings***
Documentation       Cadastro de produtos/pratos
...                 Sendo um cozinheiro amador
...                 Quero cadastrar meus melhores pratos
...                 Para que eu possa conzinha-los para outras pessoas

Resource        ../resources/base.robot

Test Setup          Login Session       antonio@yahoo.com
Test Teardown       Close Session

***Variables***
&{nhoque}=          img=nhoque.jpg    nome=Nhoque molho páprica       tipo=Massas     preco=20.00

***Test Cases***
Novo prato 
    Dado que "&{nhoque}" é um dos meus pratos
    Quando faço o cadastro desse item 
    Então devo ver esse prato no meu dashboard