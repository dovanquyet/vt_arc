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
