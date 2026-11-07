Github authentication usually requires Github CLI or Github Credentials Manager, which require `sudo` privileges to install.

If you have `sudo` privileges, you can install the Github CLI or Github Credentials Manager by following the instructions on their respective websites.

```
https://docs.github.com/en/get-started/git-basics/set-up-git
https://github.com/git-ecosystem/git-credential-manager/blob/release/docs/install.md
https://github.com/cli/cli#installation
```

Otherwise, you can follow these [instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#using-a-personal-access-token-on-the-command-line) to authenticate with Github without requiring `sudo` privileges.

Note that when you clone a repository using HTTPS, you will be prompted to enter your username and password. Instead of your password, you should use a personal access token (PAT) that you can generate from your Github account settings.

```
$ git clone https://github.com/USERNAME/REPO.git
Username: YOUR-USERNAME
Password: YOUR-PERSONAL-ACCESS-TOKEN
```

## Updated on 2026 Oct.

We can install github cli without sudo privileges by downloading the binary and adding it to the PATH. Here are the steps:
* Choose a suitable release from the [GitHub CLI releases page](https://github.com/cli/cli/releases)
* Download the binary for your operating system (e.g., `[gh_2.30.0_linux_amd64.tar.gz](https://github.com/cli/cli/releases/download/v2.103.3/gh_2.103.3_macOS_amd64.zip)` for MacOS with Intel chips)
* Extract the binary and move it to a directory in your PATH (e.g., `~/bin` or `/usr/local/bin`)
* Verify the installation by running `gh --version` in your terminal
* Then you can authenticate with GitHub using `gh auth login` and follow the prompts to authenticate with your GitHub account.
