# Contribute to the Repository
Thank you for your interest in contributing to into this repository. This guide
details how to contribute this repository efficiently.

<br/>
## Code of Conducts
As contributors and maintainers of this project, we pledge to respect all
people who contribute through reporting issues, posting feature requests,
updating documentation, submitting pull requests or patches, and other
activities. We are committed to making participation in this project a
harassment-free experience for everyone, regardless of level of experience,
gender, gender, identity and expression, sexual orientation, disability,
personal appearance, body size, race, ethnicity, age, or religion.

<br/>
Examples of unacceptable behavior by participants include the use of sexual
language or imagery, derogatory comments or personal attacks, trolling, public
or private harassment, insults, or other unprofessional conduct.

<br/>
Project maintainers have the right and responsibility to remove, edit, or
reject comments, commits, code, wiki edits, issues, and other contributions
that are not aligned to this Code of Conduct. Project maintainers who do not
follow the Code of Conduct may be removed from the project team. This code of
conduct applies both within project spaces and in public spaces when an
individual is representing the project or its community.

<br/>
Instances of abusive, harassing, or otherwise unacceptable behavior can be
reported by emailing to [legal@zoralab.com](mailto:legal@zoralab.com)

This Code of Conduct is adapted from the Contributor Covenant, version 1.1.0,
available at http://contributor-covenant.org/version/1/1/0/.

<br/>
## Agreement
By submitting code as an individual, you're automatically agreed to our
[individual contributor license agreement](https://gitlab.com/ZORALab/Resources/blob/master/contributing/individual_agreement.md).

By submitting code as an entity, you're automatically agreed to our
[corporate contributor license agreement](https://gitlab.com/ZORALab/Resources/blob/master/contributing/corporate_agreement.md).

<br/>
## Steps
### Step 1: Always file an issue
Found a bug? has a new idea? got a question? Always file an issue in the Issue
Tracker and label them as the ~"Discussion" label. In case you know who is the
maintainer, you can tag him into the issue as well.

<br/>
Normally we'll review the values of efforts, sharing and understanding the idea
and by making the discussion open, you can attract like-minded individuals to
contribute together too!

<br/>
### Step 2: Setting up
By default, this repository is a continuous integration software development.
Once the idea is favored to go and you're ready for code contribution, label
the issue with ~"Doing" label. You can proceed by forking the repository under
your account.

<br/>
If GitLab CI is supported in this repository, please do proceed to setup
the necessary environment, such as
[installing the runner](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner).
Normally, the CI will handles the testing automation for you unless your
involved in its code development. Hence, you just need to focus on developing
your codes and test scripts.


<br/>
### Step 3: Checkout next branch
The master branch is a protected branch. Since this is your forked repository,
you can proceed to develop the solution in the `next` branch. You can
proceed to clone your forked repository by:

Example, using SSH URL:
```
$ git clone -b <next branch> <URL>
```

You may then proceed with your development. Please do keep in mind to update 
your progress and notify your co-author too.


> NOTE:
>
> If you are a team, try to branch out and eventually, have all the commit
> merges into `next` branch for a single pull request. This simplifies the
> processes and makes thing easier for you to manage your team.

<br/>
### Step 4: Development
We do not impose any strict regulations for the `commmit messages` but do we do
have some minimum expectation.

#### 1: Write the full commit message (cause, impact, why, what)
Some of us are using different platforms to host the repository. Hence, it's
best to write out the contents of the issues inside your commit message instead
of relying on a platform's Issue tracker. Example, say your issue number is 12,
instead of doing something like this:
```git
Feature #12 - <commit title>

Fixed issue #12.
```

<br>
do something as such:
```git
hanabira/routes - fix <WHAT problem> causing <WHY>

Explain WHAT is the problem. Then how big is the IMPACT.

In new paragraph, explain WHY we need to fix it.

In new paragarph, explain what's is patch does in a nutshell. Don't explain
the codes. If you do, you need to refactor them to be readable, via git diff.
Descriptive trumpt short codes.
```

> **Rules of Thumbs**:
>
> 1. Keep the 1 line header under 80 characters width maximum. In some repo,
>    they are used for updating the CHANGELOG through automation.
>
> 2. Explain clearly what is your patch doing. you can use
>    `$ git format-patch -1 <sha>` to read the commit you had created.

<br/>
#### 2. Keep your commit title and message width to 80 characters max
Most of us are using terminals to view the commits and codes differences,
please do keep it **80 max**, thank you.

<br/>
#### 3. Keep your commit small if possible
Keep your commit a single purpose. That's how we avoid big commit. We don't
want to research your patch. Keep it short and simple.

> TIPS:
>
> if you're using `and` in your commit title, it signals a big commit.
>
> Example: for a patch this big:
> ```
> name/file - add feature A and feature B into repository
> ```
>
> You can make it into 2 commit patches:
>
> First Commit:
> ```
> name/file - add feature A into repository
> ```
>
> Second Commit:
> ```
> name/file - add feature B into repository
> ```

<br/>
#### 5. Test Your Code
Test your code before you commit a pull request. If the continuous integration
is available for you, use it. Please ensure your changes includes the test
components when it is applicable.

In area where test codes aren't applicable, do expect to write  a detailed
documentation. However, automated test cases and suites always come first.

> **The Definition of `Done`**:
>
> When we said `Done`, we meant by:
> 1. new codes development is completed **AND**
> 2. test script is completed and tested when applicable **AND**
> 3. documentations are updated when applicable **AND**
> 4. changelog is drafted if needed.

<br/>
### Step 6: Rebase with the remote next branch
Chances are, before you create a pull request, please rebase your branch
with the remote `next` branch and get the latest pull. The steps are
as follows:
```bash
$ git remote add upstream <remote original branch>
$ git fetch upstream
$ git rebase upstream/<remote original branch name>
```

<br/>
### Step 7: Raise merge request
You're ready. Go ahead and raise the pull request. These are the critical
things you need to do in your issue tracker:

1. If you have the drafted `changelog` message, mention it in your issue ticket.

> NOTE:
>
> Don't worry, the maintainer will add the details into the changelog prior
> to releasing to `master` branch.

<br/>
## Styles and Coding Guidelines
There are various coding languages and documentations in this repository.
Please follow the following guidelines appropriately.

### Secrets
> **IMPORTANT NOTE**:
> 
> DO NOT post your secrets onto the repository, not even `committing` it to
> your local git repo. It's very hard to clean those details after `commit` and
> is very dangerous since it exposes the secrets to the open public, sometimes
> can incur personal losses is not limited to financial aspect too.

Use separate source file or environment variables if possible. If you're using
separate source file, remember to add the filename into the `.gitignore`.

### Coding Guidelines
You should fully respect the coding guidelines mentioned in the README.md or
wiki or equivalent.
