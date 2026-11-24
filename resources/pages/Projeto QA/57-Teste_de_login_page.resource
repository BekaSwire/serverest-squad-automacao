*** Settings ***
Documentation    Page Object — Projeto QA.
...              Centraliza locators e acoes atomicas.
Resource         ../../../utils/resources.resource

*** Variables ***
${TXT_EMAIL}        xpath://*[@id='email' or @name='email' or @data-testid='email' or (normalize-space(.)='email' and not(.//*[normalize-space(.)='email']))]
${TXT_PASSWORD}        xpath://*[@id='password' or @name='password' or @data-testid='password' or (normalize-space(.)='password' and not(.//*[normalize-space(.)='password']))]
${BTN_BTN_LOGIN}        xpath://*[@id='btn-login' or @name='btn-login' or @data-testid='btn-login' or (normalize-space(.)='btn-login' and not(.//*[normalize-space(.)='btn-login']))]

${TIMEOUT}        10s

*** Keywords ***
Acessar URL Inicial
    [Documentation]    Abre o browser e navega para a URL base. BASE_URL vem de fixtures/environment.
    Should Not Be Empty    ${BASE_URL}    msg=BASE_URL nao definido. Carregue fixtures/environment.
    Open Browser Headless Aware    ${BASE_URL}
    Maximize Browser Window

Preencher Email
    [Arguments]    ${valor}
    Wait And Input Text    ${TXT_EMAIL}    ${valor}    ${TIMEOUT}

Preencher Password
    [Arguments]    ${valor}
    Wait And Input Text    ${TXT_PASSWORD}    ${valor}    ${TIMEOUT}

Clicar Btn Login
    Wait And Click Element    ${BTN_BTN_LOGIN}    ${TIMEOUT}
