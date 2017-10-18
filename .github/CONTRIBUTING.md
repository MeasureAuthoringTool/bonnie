# :clipboard: Bonnie contribution rules
1. All tickets relating to a pull request must link to the pull request.
2. All pull requests must link to their parent tickets.
3. All pull requests must have accompanying tests. This means:
    * Automated tests: Automated tests are expected unless they are not feasible. If they are not feasible, this should be explained in the pull request.
    * A JIRA test should be included if the automated tests are not sufficient
        - The JIRA test should link to the pull request
        - The JIRA test should link to the tasks that were resolved by the pull request
    * A pull request review also includes a review of the accompanying tests tests
4. All pull requests must pass a calculation regression test to confirm that calculations do not break with these changes

:clipboard: For more details see: https://gitlab.mitre.org/bonnie/internal-documentation/wikis/pull-requests

As a reviewer of a pull request, you are accountable to verifying that the PR contains all items. :punch:
