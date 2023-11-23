# Contributing to PSAIA

First of all, thank you for taking time to make contributions to PSAIA!
This file provides the more technical guidelines on how to realize it.
For more non-technical aspects, please refer to the [PSAIA Contribution Guide](./community/contribution_guide.md)

## Table of Contents

- [Got a question?](#got-a-question)
- [Structure of the package](#structure-of-the-package)
- [Submitting an Issue](#submitting-an-issue)
- [Comment style for documentation](#comment-style-for-documentation)
- [Code formatting style](#code-formatting-style)
- [Generating code coverage report](#generating-code-coverage-report)
- [Adding a unit test](#adding-a-unit-test)
- [Running unit tests](#running-unit-tests)
- [Debugging the codes](#debugging-the-codes)
- [Submitting a Pull Request](#submitting-a-pull-request)
- [Commit message guidelines](#commit-message-guidelines)

## Got a question?

Please referring to our GitHub [issue tracker](https://github.com/deepmodeling/abacus-develop/issues), and our developers are willing to help.
If you find a bug, you can help us by submitting an issue to our GitHub Repository. Even better, you can submit a Pull Request with a patch. You can request a new feature by submitting an issue to our GitHub Repository.
If you would like to implement a new feature, please submit an issue with a proposal for your work first, and that ensures your work collaborates with our development road map well. For a major feature, first open an issue and outline your proposal so that it can be discussed. This will also allow us to better coordinate our efforts, prevent duplication of work, and help you to craft the change so that it is successfully accepted into the project.

## Structure of the package

Please refer to [our instructions](./quick_start/easy_install.md) on how to installing PSAIA.
The source code of PSAIA is based on several modules. Under the PSAIA root directory, there are the following folders:

- `docs`: documents and supplementary info about PSAIA;
- `examples`: some examples showing the usage of PSAIA;
- data: some test cases of PSAIA;
- result: result files of test cases;
- work: main shell files of PSAIA;

For those who are interested in the source code, the following figure shows the structure of the source code.

```
|-- main                         A basic file including 
|   |                           (1) activate naccess file
|   |                           (2) use the files clean_file.sh, divide_patch.sh, and sort_patch.sh in order.
|-- clean_file                  clean useless file in directory
|   |-- module_ao               Atomic orbital basis set to be refactored.
|   |-- module_nao              New numerical atomic orbital basis set for two-center integrals in LCAO calculations
|   `-- module_pw               Data structures and relevant methods for planewave involved calculations
|-- divide_patch                divide patch based on contact,calculate PSAIA scores for every patch.
|   |-- module_neighbor         The module for finding the neighbors of each atom in the unit cell.
|   |-- module_paw              The module for performing PAW calculations.
|   |-- module_symmetry         The module for finding the symmetry operations of the unit cell.
|-- sort_patch                  sort patch's PSAIA score, give a ranking of patches,take the top patches with the highest scores for each chain as the result.
|   |-- module_charge           The module for calculating the charge density, charge mixing
|   |-- potentials              The module for calculating the potentials, including Hartree, exchange-correlation, local pseudopotential, etc.
```

## Submitting an Issue

Before you submit an issue, please search the issue tracker, and maybe your problem has been discussed and fixed. You can [submit new issues](https://github.com/deepmodeling/abacus-develop/issues/new/choose) by filling our issue forms.
To help us reproduce and confirm a bug, please provide a test case and building environment in your issue.

## Comment style for documentation

PSAIA uses Doxygen to generate docs directly from `.h` and `.cpp` code files.

For comments that need to be shown in documents, these formats should be used -- **Javadoc style** (as follow) is recommended, though Qt style is also ok. See it in [official manual](https://www.doxygen.nl/manual/docblocks.html).

- Tips
  - Only comments in .h file will be visible in generated  by Doxygen + Sphinx;
  - Private class members will not be documented;
  - Use [Markdown features](https://www.doxygen.nl/manual/markdown.html), such as using a empty new line for a new paragraph.

- Detailed Comment Block

    ```cpp
    /**
    * ... text ...
    */
    ```

- Brief + Detailed Comment Block

    ```cpp
    /// Brief description which ends at this dot. Details follow
    /// here.

    /// Brief description.
    /** Detailed description. */
    ```

- Comments After the Item: Add a "<"

    ```cpp
    int var; /**<Detailed description after the member */
    int var; ///<Brief description after the member
    ```

- Parameters
    usage: `[in],[out],[in,out] description`
    *e.g.*

    ```cpp
    void foo(int v/**< [in] docs for input parameter v.*/);
    ```

    or use `@param` command.

- Formula
  - inline: `\f$myformula\f$`
  - separate line: `\f[myformula\f]`
  - environment: `\f{environment}{myformula}`
  - *e.g.*

    ```latex
    \f{eqnarray*}{
            g &=& \frac{Gm_2}{r^2} \\
            &=& \frac{(6.673 \times 10^{-11}\,\mbox{m}^3\,\mbox{kg}^{-1}\,
                \mbox{s}^{-2})(5.9736 \times 10^{24}\,\mbox{kg})}{(6371.01\,\mbox{km})^2} \\
            &=& 9.82066032\,\mbox{m/s}^2
    \f}
    ```

## Adding a unit test

We use [GoogleTest](https://github.com/google/googletest) as our test framework. Write your test under the corresponding module folder at `abacus-develop/tests`, then append the test to `tests/CMakeLists.txt`. If there are currently no unit tests provided for the module, do as follows. `module_base` provides a simple demonstration.

- Add a folder named `test` under the module.
- Append the content below to `CMakeLists.txt` of the module:

    ```cmake
    IF (BUILD_TESTING)
      add_subdirectory(test)
    endif()
    ```

- Add a blank `CMakeLists.txt` under `module*/test`.

To add a unit test:

- Write your test under `GoogleTest` framework.
- Add your testing source code with suffix `*_test.cpp` in `test` directory.
- Append the content below to `CMakeLists.txt` of the module:

    ```cmake
    AddTest(
      TARGET <module_name>_<test_name> # this is the executable file name of the test
      SOURCES <test_name>.cpp

      # OPTIONAL: if this test requires external libraries, add them with "LIBS" statement.
      LIBS math_libs # `math_libs` includes all math libraries in ABACUS.
    )
    ```

- Build with `-D BUILD_TESTING=1` flag, `cmake` will look for `GoogleTest` in the default path (usually `/usr/local`); if not found, you can specify the path with `-D GTEST_DIR`. You can find built testing programs under `build/source/<module_name>/test`.
- Follow the installing procedure of CMake. The tests will move to `build/test`.
- Considering `-D BUILD_TESTING=1`, the compilation will be slower compared with the case `-D BUILD_TESTING=0`.

## Running unit tests

1. Compiling ABACUS with unit tests.   

    In order to run unit tests, ABACUS needs to be configured with `-D BUILD_TESTING=ON` flag. For example:
    ```bash
    cmake -B build -DBUILD_TESTING=ON
    ```
    then build ABACUS and unit testing with 
    ```bash
    cmake --build build -j${number of processors}
    ```
    It is import to run the folloing command before running unit tests:
    ```bash
    cmake --install build
    ```
    to install mandatory supporting input files for unit tests.  
    If you modified the unit tests to add new tests or learn how to write unit tests, it is convenient to run
    ```bash
    cmake --build build -j${number of processors} --target ${unit test name}
    ```
    to build a specific unit test. And please remember to run `cmake --install build` after building the unit test if the unit test requires supporting input files.

2. Running unit tests

    The test cases are located in `build/source/${module_name}/test` directory. Note that there are other directory names for unit tests, for example, `test_parallel` for running parallel unit tests, `test_pw` for running unit tests only used in plane wave basis calculation.  

    You can run a single test in the specific directory. For example, run
    ```
    ./cell_unitcell_test
    ```
    in the director of `build/source/cell/test` to run the test `cell_unitcell_test`.  
    However, it is more convenient to run unit tests with `ctest` command under the `build` directory. You can check all unit tests by
    ```bash
    ctest -N
    ```
    The results will be shown as  
    ```
    Test project /root/abacus/build
    Test   #1: integrated_test
    Test   #2: Container_UTs
    Test   #3: base_blas_connector
    Test   #4: base_blacs_connector
    Test   #5: base_timer
    ...
    ```
    Note that the first one is integrated test, which is not a unit test. It is the test
    suite for testing the whole ABACUS package. The examples are located in the `tests/integrate` directory.

    To run a subset of tests, run the following command 
    ```bash
    ctest -R <test-match-pattern> -V
    ```
    For example, `ctest -R cell` will perform tests with name matched by `cell`.  
    You can also run a single test with 
    ```
    ctest -R <test-name>
    ```
    For example, `ctest -R cell_unitcell_test_readpp` will   perform test `cell_unitcell_test_readpp`.  
    To run all the unit tests, together with the integrated test, run
    ```bash
    cmake --build build --target test ARGS="-V --timeout 21600"
    ```
    in the `abacus-develop` directory.

## Submitting a Pull Request

1. [Fork](https://docs.github.com/en/github/getting-started-with-github/fork-a-repo) the [PSAIA repository]([RUC-MIALAB/PSAIA: This is a program for predicting protein binding sites. (github.com)](https://github.com/RUC-MIALAB/PSAIA)). If you already had an existing fork, [sync](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork) the fork to keep your modification up-to-date.

2. Pull your forked repository, create a new git branch, and make your changes in it:

     ```shell
     git checkout -b my-fix-branch
     ```

3. Coding your patch, including appropriate test cases and docs.
To run a subset of unit test, use `ctest -R <test-match-pattern>` to perform tests with name matched by given pattern.

4. After tests passed, commit your changes [with a proper message](#commit-message-guidelines).

5. Push your branch to GitHub:

    ```shell
    git push origin my-fix-branch
    ```

6. In GitHub, send a pull request (PR) with `deepmodeling/abacus-develop:develop` as the base repository. It is required to document your PR following [our guidelines](#commit-message-guidelines).

7. After your pull request is merged, you can safely delete your branch and sync the changes from the main (upstream) repository:

- Delete the remote branch on GitHub either [through the GitHub web UI](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-branches-in-your-repository/deleting-and-restoring-branches-in-a-pull-request#deleting-a-branch-used-for-a-pull-request) or your local shell as follows:

    ```shell
    git push origin --delete my-fix-branch
    ```

- Check out the master branch:

    ```shell
    git checkout develop -f
    ```

- Delete the local branch:

    ```shell
    git branch -D my-fix-branch
    ```

- Update your master with the latest upstream version:

    ```shell
    git pull --ff upstream develop
    ```

## Commit message guidelines

A well-formatted commit message leads a more readable history when we look through some changes, and helps us generate change log.
We follow up [The Conventional Commits specification](https://www.conventionalcommits.org) for commit message format.
This format is also required for PR title and message.
The commit message should be structured as follows:

```text
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

- Header
  - type: The general intention of this commit
    - `Feature`: A new feature
    - `Fix`: A bug fix
    - `Docs`: Only documentation changes
    - `Style`: Changes that do not affect the meaning of the code
    - `Refactor`: A code change that neither fixes a bug nor adds a feature
    - `Perf`: A code change that improves performance
    - `Test`: Adding missing tests or correcting existing tests
    - `Build`: Changes that affect the build system or external dependencies
    - `CI`: Changes to our CI configuration files and scripts
    - `Revert`: Reverting commits
  - scope: optional, could be the module which this commit changes; for example, `orbital`
  - description: A short summary of the code changes: tell others what you did in one sentence.
- Body: optional, providing detailed, additional, or contextual information about the code changes, e.g. the motivation of this commit, referenced materials, the coding implementation, and so on.
- Footer: optional, reference GitHub issues or PRs that this commit closes or is related to. [Use a keyword](https://docs.github.com/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword) to close an issue, e.g. "Fix #753".

Here is an example:

```text
Fix(lcao): use correct scalapack interface.

`pzgemv_` and `pzgemm_` used `double*` for alpha and beta parameters but not `complex*` , this would cause error in GNU compiler.

Fix #753.
```
