*** Settings ***
Library    RPA.Browser
Resource    ../resources/currency.resource
Suite Setup     Open Available Browser    https://google.com
Suite Teardown    Close Browser
Variables    ../variables/properties.yaml

*** Variables ***
${stock}    ${EMPTY}


*** Tasks ***
Check Stock from Aumann
    [Setup]    Prepare environment for ${AUMANN}
    ${stock_rate}   Get stock rate
    Validate lower threshold for rate '${stock_rate}'
    Validate upper threshold for rate '${stock_rate}'


*** Keywords ***
Prepare environment for ${runtime_stock}
    log    ${runtime_stock}
    Set Global Variable    ${stock}    ${runtime_stock}

Open website for stock rates
    Go to    ${stock}[url]
    Wait Until Page Contains    ${stock}[title]

Get stock rate from website
    Open website for stock rates
    ${stock_rate}    Get Text    ${stock}[xpath_current_value]
    Log    ${stock_rate}
    [Return]    ${stock_rate}

Get stock rate
    ${stock_rate}   Get stock rate from website
    ${current_stock_rate}    Convert ${stock_rate} to Number
    [Return]    ${current_stock_rate}

Validate lower threshold for rate '${stock_rate}'
    ${threshold_rates}    Get threshold minimum from ${stock}
    FOR    ${loss_rate}    IN    @{threshold_rates}
        Run Keyword If    ${stock}[check_loss]    Should Not Be True    ${loss_rate}[threshold] > ${stock_rate}    Action needed. ${stock}[title] is below ${loss_rate}[threshold] € :\t${stock_rate} €\nOrder:\t${loss_rate}[order]
    END

Validate upper threshold for rate '${stock_rate}'
    ${threshold_rates}    Get threshold maximum from ${stock}
    FOR    ${win_rate}    IN    @{threshold_rates}
        Run Keyword If    ${stock}[check_win]    Should Not Be true    ${win_rate}[threshold] < ${stock_rate}    Action needed. ${stock}[title] is over ${win_rate}[threshold] €:\t${stock_rate} €\nOrder:\t${win_rate}[order]
    END