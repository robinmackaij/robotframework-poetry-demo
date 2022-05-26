*** Settings ***
Resource    Global/Variables.resource


*** Keywords ***
Get Robot Framework Resource Urls
    ${urls}=    Create List    ${MAIN_SITE_URL}    ${FORUM_URL}    ${MARKETSQUARE_URL}
    RETURN    ${urls}
