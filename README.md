# [Limbo](https://medium.com/@kentbeck_7670/limbo-scaling-software-collaboration-afd4f00db4b)

In the spirit of Kent Beck's "[test && commit || revert](https://medium.com/@kentbeck_7670/test-commit-revert-870bbd756864)" (TCR), this loose adaptation of Limbo uses Git to track the most recent version of the code that passes tests, and (more importantly) to remove any code that doesn't.

User-provided git commit messages are eschewed by this process, as they slow the rate of TCR. As such, the commit message is hard-coded to point the reader toward the README. In development, the standard git tools which are commit-aware are aliased (e.g., `git llog` for "limbo log") to versions which ignore the commit message. In the case of reversions (which, given good test hygiene, should be few), tools like `git bisect` are suggested to be run in a date range or from tag to tag.

In cases where a commit message would normally be used to annotate e.g., a feature or bugfix, the suggested alternative is an annotated tag. Given the core tenet of Limbo is to never push a commit that will cause problems to others (including users), the concept of releases (a typical use of annotated tags, usually reserved for a vetted, "blessed" version of the code) should be able to be applied to any commit, arbitrarily, and as needed.

# How to use
## Make `limbo` available in-shell
If you run the Bourne again Shell (Bash), simply source `bash_limbo`:

    . bash_limbo
    
or

    source bash_limbo

I soft-link this into my home directory as a `.bash_limbo` and source from `.bashrc`.

If you don't run the bash shell, for the moment, you're on your own.

## Develop with `limbo`
In the top-level of your repository (`limbo` checks for `.git` directory), run `limbo "<test comand>"`. `<test command>` should (ideologically) test your entire repository and (practically) return 0 on success and any "false" value on failure.

Alternatively, you can put your `<test command>` in the `.limbo` file in the top level of your repository.

The contents of `<test command>` are evaluated with the `eval` builtin, which returns the return code of the last executed line. If you want a multi-line test command, you'll need to append `&&` to all but the last line.

**Note:** In keeping with the "Limbo" philosophy, `limbo` runs `git push` after *every successful commit*.

# Fitness for use
I guarantee nothing about the fitness of this project for any purpose, least of all actual software development. I can't even begin to imagine how one might use it in an environment where code review is expected (though Kent Beck would probably argue that the entire point of Limbo is not to do blocking code reviews).
