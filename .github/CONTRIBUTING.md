# :clipboard: Bonnie contribution rules
1. All tickets relating to a pull request must link to the pull request.
    * Also include link in the pull request back to the ticket.
2.	All pull requests must have accompanying tests. This means: 
    * **JIRA tests**: The JIRA tests should outline all of the steps needed to test the change and should be usable prior to release of this issue. 
        - The JIRA test should link to the pull request
        - The JIRA test should link to the tasks that were resolved by the pull request
    * If possible, it also contain an automated test for the pull request that gets reviewed along with the pull request.
3. \(Optional) Regression test screenshots before/after. [This Chrome plugin](https://chrome.google.com/webstore/detail/full-page-screen-capture/fdpohaocaechififmbbbbbknoalclacl) may or may not be of use to you, perhaps merely adjusting the zoom level can get everything into a single screenshot. *See https://jira.mitre.org/browse/BONNIE-744*.  Alternatively, you can use the automated regression script: https://gitlab.mitre.org/bonnie/server-scripts/blob/master/regression_test

:clipboard: For more details see: https://gitlab.mitre.org/bonnie/internal-documentation/wikis/pull-requests

As a reviewer of a pull request, you are accountable to verifying that the PR contains all items. :punch:


