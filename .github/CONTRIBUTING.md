# Welcome to charts contributing guide <!-- omit in toc -->

Thank you for investing your time in contributing to our project! ✨

In this guide you will get an overview of the contribution workflow from opening an issue, creating a PR, reviewing, and merging the PR.


## Getting started

### Issues

#### Create a new issue

If you spot a problem with any chart, [search if an issue already exists](https://docs.github.com/en/github/searching-for-information-on-github/searching-on-github/searching-issues-and-pull-requests#search-by-the-title-body-or-comments). If a related issue doesn't exist, you can open a new issue using a relevant [issue form](https://github.com/homarr-labs/charts/issues/new/choose).

#### Solve an issue

Scan through our [existing issues](https://github.com/homarr-labs/charts/issues) to find one that interests you. You can narrow down the search using `labels` as filters. See "[Label reference](https://docs.github.com/en/contributing/collaborating-on-github-docs/label-reference)" for more information. As a general rule, we don’t assign issues to anyone. If you find an issue to work on, you are welcome to open a PR with a fix.

### Make Changes

#### Make changes locally

1. Fork the repository.
- Using GitHub Desktop:
    - [Getting started with GitHub Desktop](https://docs.github.com/en/desktop/installing-and-configuring-github-desktop/getting-started-with-github-desktop) will guide you through setting up Desktop.
    - Once Desktop is set up, you can use it to [fork the repo](https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/cloning-and-forking-repositories-from-github-desktop)!

- Using the command line:
    - [Fork the repo](https://docs.github.com/en/github/getting-started-with-github/fork-a-repo#fork-an-example-repository) so that you can make your changes without affecting the original project until you're ready to merge them.

2. 🌱 Setup your local workstation
   1. Install the most recent version of [task](https://taskfile.dev/), see the [installation docs](https://taskfile.dev/installation/) for other supported platforms.

       ```shell
       # Homebrew
       brew install go-task
       ```

   2. Install the additional **required** CLI tools

      📍 _**Not using Homebrew?** Try using the generic Linux task below, if that fails check out the [Brewfile](.taskfiles/Workstation/Brewfile)) for what CLI tools needed and install them._

        ```shell
        # Homebrew
        task workstation:brew
        # or, Generic Linux (YMMV, this pulls binaires in to ./bin)
        task workstation:generic-linux
        ```
3. Create a working branch and start with your changes!

4. Once your are happy with your changes:
   We've provided shell scripts in the `hack` folder to assist you in managing the Helm chart:
   1. Lint the chart:

      Run the following command to lint your Helm chart:
      ```shell
      ./helm-lint.sh
       ```
   2. Render Templates Locally:

      To render the Helm chart templates locally, use:
      ```shell
      ./helm-template.sh
       ```
      📍 **Make sure to review the rendered templates to verify your changes.**
   3. Packaging and Testing the Chart Locally:

      For instructions on packaging and testing the Helm chart locally, refer to the [Development Guide](../development/README.md)
   3. You can find how to package and test your chart locally under [Development directory](../development/README.md)
   4. Update the chart version:

       ```shell
      ./update-version.sh <UPDATE_TYPE>
      # Example: ./update-version.sh minor
       ```
      📍 **Update types available :** major, minor or patch

   5. Change the artifacthub.io/changes label on Chart.yaml :

       ```shell
      ./update-changelog.sh <CHANGE_KIND> "<DESCRIPTION>"
      # Example: ./update-changelog.sh "fixed" "hot fix"
       ```
      📍 **change kinds available :** added, changed or fixed
   6. Update the documentation
      ```shell
      ./gen-helm-docs.sh
      ```
   7. Optional : Check linting & generating docs using pre-commit:
      ```shell
      pre-commit run --all-files
      ```

   8. Commit your update.
   9. When you're finished with the changes, create a pull request.
