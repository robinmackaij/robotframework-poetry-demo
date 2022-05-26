*** Settings ***
Resource    Global/Keywords.resource


*** Test Cases ***
Can Get Robot Framework Resource Urls
    ${urls}=    Get Robot Framework Resource Urls
    Should Contain    ${urls}    ${MAIN_SITE_URL}
    Should Contain    ${urls}    ${FORUM_URL}
    Should Contain    ${urls}    ${MARKETSQUARE_URL}
