*** Settings ***
Resource    Flat/Keywords.resource


*** Test Cases ***
Can Get Url
    ${url}=    Get Main Site Url
    Should Be Equal    ${url}    ${MAIN_URL}
