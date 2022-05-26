*** Settings ***
Resource    UserGuide/Keywords.resource


*** Test Cases ***
Can Get User Guide Url
    ${url}=    Get User Guide Url
    Should Be Equal    ${url}    ${USER_GUIDE_URL}
