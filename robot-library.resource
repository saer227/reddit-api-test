*** Settings ***
Documentation     A resource file with reusable keywords and variables
Library           SeleniumLibrary

*** Variables ***
${DELAY}    0

*** Keywords ***
Open Browser To URL
    [Arguments]  ${browser}  ${url}
    [Documentation]  Opens browser of type ``browser`` to ``url``
    Open Browser          ${url}    ${browser}
    Set Selenium Speed    ${DELAY}
