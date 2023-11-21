Pull requests into Bonnie require the following. Submitter and reviewer should :white_check_mark: when done. For items that are not-applicable, note it's not-applicable ("N/A") and :white_check_mark:.

**Submitter:**
- [ ] This pull request describes why these changes were made.
- [ ] This PR is into the correct branch.
- [ ] JIRA ticket for this PR:
- [ ] JIRA ticket links to this PR
- [ ] Code diff has been done and been reviewed (it **does not** contain: additional white space, not applicable code changes, debug statements, etc.)
- [ ] If UI changes have been made, google WAVE plug-in has been executed to ensure no 508 issues were introduced.
- [ ] Tests are included and test edge cases
- [ ] Tests have been run locally and pass (remember to update Gemfile when applicable)
- [ ] Code coverage has not gone down and all code touched or added is covered. 
     * In rare situations, this may not be possible or applicable to a PR. In those situations:
         1. Note why this could not be done or is not applicable here: 
         2. Add TODOs in the code noting that it requires a test
         3. Add a JIRA task to add the test and link it here: 
- [ ] Automated regression test(s) pass

If JIRA tests were used to supplement or replace automated tests:
- [ ] JIRA test links:
- [ ] Justification for using JIRA tests:
- [ ] JIRA tests have been added to sprint


**Reviewer 1:**

Name:
- [ ] Code is maintainable and reusable, reuses existing code and infrastructure where appropriate, and accomplishes the task’s purpose
- [ ] The tests appropriately test the new code, including edge cases

If JIRA tests were used to supplement or replace automated tests:
- [ ] JIRA tests have been run and pass
- [ ] You agree with the justification for use of JIRA tests or have provided input on why you disagree


**Reviewer 2:**

Name:
- [ ] Code is maintainable and reusable, reuses existing code and infrastructure where appropriate, and accomplishes the task’s purpose
- [ ] The tests appropriately test the new code, including edge cases
- [ ] You have tried to break the code

If JIRA tests were used to supplement or replace automated tests:
- [ ] JIRA tests have been run and pass
- [ ] You agree with the justification for use of JIRA tests or have provided input on why you disagree
