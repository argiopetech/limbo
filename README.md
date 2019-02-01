# [Limbo](https://medium.com/@kentbeck_7670/limbo-scaling-software-collaboration-afd4f00db4b)

In the spirit of Kent Beck's "[test && commit || revert](https://medium.com/@kentbeck_7670/test-commit-revert-870bbd756864)" (TCR), this loose adaptation of Limbo uses Git to track the most recent version of the code that passes tests, and (more importantly) to remove any code that doesn't.

Git commit messages are eschewed by this process, as they slow the rate of TCR. As such, the commit message is hard-coded to point the reader toward the README. In development, the standard git tools which are commit-aware are aliased (e.g., `git llog` for "limbo log") to versions which ignore the commit message. In the case of reversions (which, given good test hygiene, should be few), tools like `git bisect` are suggested to be run in a date range or from tag to tag.

In cases where a commit message would normally be used to annotate e.g., a feature or bugfix, the suggested alternative is an annotated tag. Given the core tenet of Limbo is to never push a commit that will cause problems to others (including users), the concept of releases (a typical use of annotated tags, usually reserved for a vetted, "blessed" version of the code) should be able to be applied to any commit, arbitrarily, and as needed.

# How to use
If you run the Bourne again Shell (BASH), simply source functions.sh:

    . functions.sh
    
or

    source functions.sh
    
If you don't run BASH, for the moment, you're on your own.

# Fitness for use
I guarantee nothing about the fitness of this project for any purpose, least of all actual software development. I can't even begin to imagine how one might use it in an environment where code review is expected (though Kent Beck would probably argue that the entire point of Limbo is not to do blocking code reviews).
