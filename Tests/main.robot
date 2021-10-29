*** Settings ***

Resource         ../Resources/data.robot
Resource         ../Resources/elements.robot
Test Teardown    Close Browser


*** Test Cases ***

Validate page header
    go to Robot framework page
    Validate Header data

Check if it's possible to navigate to SeleniumLibrary
    go to Robot framework page
    Navigate to SeleniumLibrary

Check if "Element should be enabled" function exists
    Go to Robot framework page
    Navigate to SeleniumLibrary
    See if "Element should be enabled" function exists


