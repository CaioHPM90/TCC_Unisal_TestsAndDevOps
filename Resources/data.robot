*** Settings ***

Library        SeleniumLibrary
Library        RequestsLibrary
Library        JSONLibrary
Library        Collections
Resource       elements.robot  

*** Variables ***

${board_id}                606b3b527356c551f0f1cca9
${board_name}              Board Automation
${trello_key}              e9b55d67d5d7736442521d048d692eb8
${trello_token}            da61b7431a0d6e4563491e36c9bfcbb0c3480b5d41429158461a9ef0a686b683
${trello_baseurl}          https://api.trello.com/1/
${url_robotframework}      https://robotframework.org/
${browser}                 Chrome
${column_Test}             606b3b53395af651e7a73912
${column_passedTests}      606b3b527356c551f0f1ccab
${column_failedTests}      606b3b527356c551f0f1ccaa
${board_id}                606b3b527356c551f0f1cca9  

*** Keywords ***

Go to Robot framework page
    Open browser                ${url_robotframework}        ${browser} 

Validate Header data
   ${msg}=   Run Keyword And Return Status  Wait Until Element Is Visible         ${header_introductionBtn} 
   ${msg1}=  Run Keyword And Return Status  Wait Until Element Is Visible         ${header_gettingStartedBtn}
   ${msg2}=  Run Keyword And Return Status  Wait Until Element Is Visible         ${header_communityBtn}  
   ${msg3}=  Run Keyword And Return Status  Wait Until Element Is Visible         ${header_resourcesBtn} 
   ${msg4}=  Run Keyword And Return Status  Wait Until Element Is Visible         ${header_developmentBtn}

   Run Keyword if  "${msg}"=="True" and "${msg1}"=="True" and "${msg2}"=="True" and "${msg3}"=="True" and "${msg4}"=="True"        Update Trello Card Column    ${board_id}     Validate Header data    Passed Tests
       
   Run Keyword if  "${msg}"=="False" or "${msg1}"=="False" or "${msg2}"=="False" or "${msg3}"=="False" or "${msg4}"=="False"      Update Trello Card Column    ${board_id}     Validate Header data    Failed Tests


Navigate to SeleniumLibrary
    Execute Javascript                    window.scrollTo(0, window.scrollY+30)
    Click Element                         ${seleniumLibraryBtn} 
    ${msg}=   Run Keyword And Return Status      Page Should Contain                   GitHub 
    Run Keyword if  "${msg}"=="True"    Update Trello Card Column    ${board_id}    Navigate into SeleniumLibrary             Passed Tests
    Run Keyword if  "${msg}"=="False"   Update Trello Card Column    ${board_id}    Navigate into SeleniumLibrary             Failed Tests

See if "Element should be enabled" function exists
    Sleep                                 3s
    Execute Javascript                    window.scrollTo(0, window.scrollY+40)
    Click Element                         ${keywordDoc_element}
    Input text                            ${search_txt}        Element should be enabled
    ${msg}=  Run Keyword And Return Status      Page Should Contain                   Element Should Be Enabled
    Run Keyword if  "${msg}"=="True"     Update Trello Card Column    ${board_id}    Verify Element should be enabled Function existance           Passed Tests
    Run Keyword if  "${msg}"=="False"    Update Trello Card Column    ${board_id}    Verify Element should be enabled Function existance           Failed Tests
    

Update Trello Card Column
    [Arguments]     ${board_id}    ${card_title}     ${column}
    
    ${response} =         GET     url=${trello_baseurl}boards/${board_id}/cards/?key=${trello_key}&token=${trello_token}

    ${sourcedata}=    Evaluate     json.loads("""${response.content}""")    json

    ${all_cards}=    Set Variable     ${sourcedata}

    FOR    ${card}     IN      @{all_cards}  
        ${card_name}=    Get From Dictionary   ${card}     id    
        IF   "${card['name']}"=="${card_title}"
            IF     "${column}"=="Passed Tests"
                ${response} =  PUT   url=${trello_baseurl}cards/${card['id']}?key=${trello_key}&token=${trello_token}&idList=606b3b527356c551f0f1ccab
            ELSE IF     "${column}"=="Failed Tests"
                ${response} =  PUT   url=${trello_baseurl}cards/${card['id']}?key=${trello_key}&token=${trello_token}&idList=606b3b527356c551f0f1ccaa
            END
        END    
    END


