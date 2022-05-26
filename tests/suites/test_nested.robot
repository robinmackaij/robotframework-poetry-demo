*** Settings ***
Resource    Nested/Keywords/API.resource
Resource    Nested/Keywords/Web.resource


*** Test Cases ***
Can Get Icon Url
    ${url}=    Get Robot Framework Icon Url
    Should Be Equal    ${url}    ${ICON_URL}

Can Get Poetry Talk Url
    ${url}=    Get Poetry Talk Url
    Should Be Equal    ${url}    ${POETRY_TALK_URL}
