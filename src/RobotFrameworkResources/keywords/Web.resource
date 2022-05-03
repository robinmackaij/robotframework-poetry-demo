*** Settings ***
Library        Browser
Resource       ../variables/Urls.resource


*** Keywords ***
Open main site
    New Page    ${MAIN_URL}
