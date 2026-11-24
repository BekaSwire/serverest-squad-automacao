*** Settings ***
Library    SeleniumLibrary
Library    RequestsLibrary
Library    Collections
Library    String

*** Variables ***
${HEADLESS}    false
${SCREENSHOT_DIR}    ${EMPTY}
${CHROME_OPTIONS}    --no-sandbox;--disable-dev-shm-usage;--disable-gpu;--disable-extensions;--window-size=1920,1080

*** Keywords ***
Open Browser Headless Aware
    [Documentation]    Abre o browser com suporte a headless. Se HEADLESS=true,
    ...    adiciona --headless ao Chrome e configura screenshot on failure.
    [Arguments]    ${url}    ${browser}=chrome
    ${options}=    Set Variable    ${CHROME_OPTIONS}
    IF    '${HEADLESS}' == 'true'
        ${options}=    Set Variable    ${options};--headless=new
    END
    ${chrome_opts}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    FOR    ${opt}    IN    @{options.split(';')}
        Call Method    ${chrome_opts}    add_argument    ${opt}
    END
    Create Webdriver    Chrome    options=${chrome_opts}
    Go To    ${url}
    IF    '${SCREENSHOT_DIR}' != '${EMPTY}'
        Set Screenshot Directory    ${SCREENSHOT_DIR}
    END

Capture And Close Browser
    [Documentation]    Captura screenshot (evidencia) e fecha o browser. Usado
    ...    no Teardown — roda tanto em sucesso quanto em falha. Fechar o browser
    ...    e limpeza de recurso: uma falha aqui NAO deve reprovar um teste cujos
    ...    passos passaram, por isso ambas as acoes sao toleradas.
    Run Keyword And Ignore Error    Capture Page Screenshot
    Run Keyword And Ignore Error    Close Browser

Wait And Click Element
    [Documentation]    Clique resiliente: espera o elemento no DOM, rola ate ele
    ...    e tenta o clique normal; se falhar por visibilidade, cai para clique
    ...    via JavaScript. Evita falso-negativo em elementos clicaveis que o
    ...    criterio estrito de "visivel" do Selenium rejeita.
    [Arguments]    ${locator}    ${timeout}=10s
    Wait Until Page Contains Element    ${locator}    ${timeout}
    Run Keyword And Ignore Error    Scroll Element Into View    ${locator}
    ${ok}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    ${timeout}
    IF    ${ok}
        ${clicked}=    Run Keyword And Return Status    Click Element    ${locator}
        IF    not ${clicked}
            Click Element Via Javascript    ${locator}
        END
    ELSE
        Click Element Via Javascript    ${locator}
    END

Click Element Via Javascript
    [Documentation]    Fallback de clique: dispara o click no elemento via JS.
    [Arguments]    ${locator}
    ${element}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].click();    ARGUMENTS    ${element}

Wait And Input Text
    [Arguments]    ${locator}    ${text}    ${timeout}=10s
    Wait Until Element Is Visible    ${locator}    ${timeout}
    Input Text    ${locator}    ${text}

Wait And Element Should Be Visible
    [Arguments]    ${locator}    ${timeout}=10s
    Wait Until Element Is Visible    ${locator}    ${timeout}

Assert Element Text
    [Documentation]    Valida que o texto do elemento e exatamente o esperado.
    [Arguments]    ${locator}    ${expected}    ${timeout}=10s
    Wait Until Page Contains Element    ${locator}    ${timeout}
    ${actual}=    Get Text    ${locator}
    Should Be Equal As Strings    ${actual.strip()}    ${expected}    msg=Texto esperado '${expected}' mas encontrado '${actual.strip()}'

Assert Element Contains Text
    [Documentation]    Valida que o texto do elemento contem o valor esperado.
    [Arguments]    ${locator}    ${expected}    ${timeout}=10s
    Wait Until Page Contains Element    ${locator}    ${timeout}
    ${actual}=    Get Text    ${locator}
    Should Contain    ${actual}    ${expected}    msg=Texto '${actual}' nao contem '${expected}'

Assert Element Not Contains Text
    [Documentation]    Valida que o texto do elemento NAO contem o valor.
    [Arguments]    ${locator}    ${expected}    ${timeout}=10s
    Wait Until Page Contains Element    ${locator}    ${timeout}
    ${actual}=    Get Text    ${locator}
    Should Not Contain    ${actual}    ${expected}    msg=Texto '${actual}' contem '${expected}' mas nao deveria

Assert Element Text Starts With
    [Documentation]    Valida que o texto do elemento comeca com o valor esperado.
    [Arguments]    ${locator}    ${expected}    ${timeout}=10s
    Wait Until Page Contains Element    ${locator}    ${timeout}
    ${actual}=    Get Text    ${locator}
    Should Start With    ${actual.strip()}    ${expected}    msg=Texto '${actual}' nao comeca com '${expected}'

Assert Element Text Ends With
    [Documentation]    Valida que o texto do elemento termina com o valor esperado.
    [Arguments]    ${locator}    ${expected}    ${timeout}=10s
    Wait Until Page Contains Element    ${locator}    ${timeout}
    ${actual}=    Get Text    ${locator}
    Should End With    ${actual.strip()}    ${expected}    msg=Texto '${actual}' nao termina com '${expected}'

Assert Element Text Matches
    [Documentation]    Valida que o texto do elemento corresponde ao regex.
    [Arguments]    ${locator}    ${pattern}    ${timeout}=10s
    Wait Until Page Contains Element    ${locator}    ${timeout}
    ${actual}=    Get Text    ${locator}
    Should Match Regexp    ${actual}    ${pattern}    msg=Texto '${actual}' nao corresponde ao padrao '${pattern}'

Assert Title Contains
    [Documentation]    Valida que o titulo da pagina contem o texto esperado.
    [Arguments]    ${expected}
    ${actual}=    Get Title
    Should Contain    ${actual}    ${expected}
