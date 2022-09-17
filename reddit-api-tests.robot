*** Settings ***
Documentation     Suite for testing reddit api
          ...     - Finding a thread by a key
          ...     - Creating a comment
          ...     - Removing a comment

Resource          robot-library.resource
Library           reddit-api-keywords.py

Suite Setup       Reddit API Suite Setup
Suite Teardown    Reddit API Suite Teardown
Force Tags        reddit_api

*** Variables ***
${REDDIT_URL}                     https://reddit.com
${REDDIT_THREAD_ID}               xghjx0
${REDDIT_TITLE_CLASS}             _eYtD2XCVieq6emjKBH3m
${REDDIT_DESCRIPTION_CLASS}       _3xX726aBn29LDbsDtzr_6E
${REDDIT_COMMENT_CLASS}           _3cjCphgls6DH-irkVaA0GM
${EXPECTED_THREAD_TITLE}          Placeholder title
${EXPECTED_THREAD_DESCRIPTION}    Don't mind me I am just testing reddit API.
${EXPECTED_COMMENT_TEXT}          RF Test comment.
${COMMENT_ID}                     #ID of the comment that we create during tests execution

*** Test cases ***
Find A Thread By A Key Via Reddit API
    Navigate To Thread By ID                   ${REDDIT_THREAD_ID}
    Wait Until Thread Title Is Equal           ${EXPECTED_THREAD_TITLE}
    Wait Until Thread Descpription Contains    ${EXPECTED_THREAD_DESCRIPTION}

Create A Comment Via Reddit API
    Wait Until Page Does Not Contain Comment    ${EXPECTED_COMMENT_TEXT}
    ${id} =  Create Reddit Comment              ${REDDIT_THREAD_ID}    ${EXPECTED_COMMENT_TEXT}
    Set Suite Variable                          ${COMMENT_ID}    ${id}
    Make Sure Page Contains Comment             ${EXPECTED_COMMENT_TEXT}

Remove A Comment Via Reddit API
    Wait Until Page Contains Comment           ${EXPECTED_COMMENT_TEXT}
    Delete Reddit Comment                      ${COMMENT_ID}
    Make Sure Page Does Not Contain Comment    ${EXPECTED_COMMENT_TEXT}

*** Keywords ***
Reddit API Suite Setup
    Open Browser To URL    chrome    ${REDDIT_URL}

Reddit API Suite Teardown
    Close All Browsers

Navigate To Thread By ID
    [Arguments]    ${thread_id}
    ${thread_url} =  Find Reddit Thread    ${thread_id}
    Go To    ${thread_url}

Wait Until Thread Title Is Equal
    [Arguments]    ${title_text}
    Wait Until Page Contains Element    xpath://*[@class="${REDDIT_TITLE_CLASS}"][text()="${title_text}"]

Wait Until Thread Descpription Contains
    [Arguments]    ${descpription_text}
    Wait Until Page Contains Element    xpath://*[contains(@class, "${REDDIT_DESCRIPTION_CLASS}")][descendant-or-self::*/text()="${descpription_text}"]

Wait Until Page Does Not Contain Comment
    [Arguments]    ${comment_text}
    Wait Until Page Does Not Contain Element    xpath://*[contains(@class, "${REDDIT_COMMENT_CLASS}")][descendant-or-self::*/text()="${comment_text}"]

Wait Until Page Contains Comment
    [Arguments]    ${comment_text}
    Wait Until Page Contains Element    xpath://*[contains(@class, "${REDDIT_COMMENT_CLASS}")][descendant-or-self::*/text()="${comment_text}"]

Make Sure Page Contains Comment
    [Arguments]    ${comment_text}
    Wait Until Keyword Succeeds    10x    1s    Page Should Contain Comment    ${comment_text}

Page Should Contain Comment
    [Arguments]    ${comment_text}
    Reload Page
    Page Should Contain Element    xpath://*[contains(@class, "${REDDIT_COMMENT_CLASS}")][descendant-or-self::*/text()="${comment_text}"]

Make Sure Page Does Not Contain Comment
    [Arguments]    ${comment_text}
    Wait Until Keyword Succeeds    10x    1s    Page Should Not Contain Comment    ${comment_text}

Page Should Not Contain Comment
    [Arguments]    ${comment_text}
    Reload Page
    Page Should Not Contain Element    xpath://*[contains(@class, "${REDDIT_COMMENT_CLASS}")][descendant-or-self::*/text()="${comment_text}"]
