# PR comment from a `repository_dispatch` action

The main idea is:

 * Given there is a `repository_dispatch` action.
 * When the action is triggered by an API request 
   * and PR number and SHA are provided with the request payload.
 * Then and a comment is added to the provided PR, 
   * and the contents of the comment is based on the repository contents at the provided SHA.
