*** Settings ***
Resource    Shop/Keywords.resource


*** Test Cases ***
Can Get Shop Url
    ${url}=    Get Shop Url
    Should Be Equal    ${url}    ${WEB_SHOP_URL}
