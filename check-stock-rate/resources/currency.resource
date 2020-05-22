*** Settings ***
Library    Collections
Library    String

*** Keywords ***
Convert ${currency_value} to Number
    ${raw_stock_rate}    String.Remove String    ${currency_value}    ${CURRENCY}
    ${raw_stock_rate}    String.Replace String    ${raw_stock_rate}    ,    .
    ${current_stock_rate}    Convert To Number   ${raw_stock_rate}    2
    [Return]    ${current_stock_rate}

Convert order list
    [Arguments]    ${orders}
    ${normalized_orders}    Create List
    FOR    ${limit_order_pair}    IN    @{orders}
        ${result}    Convert To Number     ${limit_order_pair}[threshold]    2
        ${tmp_dict}    Create Dictionary    threshold=${result}    order=${limit_order_pair}[order]
        Append To List    ${normalized_orders}    ${tmp_dict}
    END
    [Return]    ${normalized_orders}

Get threshold minimum from ${stock}
    ${normalized_orders}    Convert order list    ${stock}[threshold_loss]
    [Return]    ${normalized_orders}

Get threshold maximum from ${stock}
    ${normalized_orders}    Convert order list    ${stock}[threshold_win]
    [Return]    ${normalized_orders}

