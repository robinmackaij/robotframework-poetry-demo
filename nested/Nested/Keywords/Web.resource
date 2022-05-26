*** Settings ***
Resource    Nested/Variables/Global.resource


*** Keywords ***
Get Poetry Talk Url
    RETURN    ${POETRY_TALK_URL}
