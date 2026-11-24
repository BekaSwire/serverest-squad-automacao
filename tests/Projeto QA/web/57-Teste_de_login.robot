*** Settings ***
Documentation    59-yyyyy
...              Gerado pelo QaCoders Automation Agent.
...
...              Variaveis sensiveis (definir em .env ou CI):
...                  - PASSWORD
Library          OperatingSystem
Resource         ../../../utils/resources.resource
Resource         ../../../resources/pages/Projeto QA/57-Teste_de_login_page.resource

*** Test Cases ***
59-yyyyy
    [Documentation]    Teste gerado pelo QaCoders Automation Agent
    [Tags]    AT-59    Generated    Web
    [Teardown]    Capture And Close Browser

    ${PASSWORD}=    Get Environment Variable    PASSWORD

    Acessar URL Inicial
    Preencher Email    ${EMAIL}
    Preencher Password    ${PASSWORD}
    Clicar Btn Login
