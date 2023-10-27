# Shellcheck test Rule

The shellcheck test rule is useful to run shellcheck against shell script files.

## Getting Started

To import rules_shellcheck in your project, you first need to add it to your `MODULE.bazel` file:

```python
bazel_dep(name = "rules_shellcheck", version = "0.0.1")
git_override(
    module_name = "rules_shellcheck",
    remote      = "https://github.com/yanndegat/rules_shellcheck",
    commit      = "",
)
```

Once you've imported the rule set , you can then load the tf rules in your `BUILD` files with:

```python
load("@rules_shellcheck//shellcheck:def.bzl", "shellcheck_test")

shellcheck_test(
    name = "test",
    srcs = glob(["*.sh"]),
    tags = [
        "lint",
    ],
)
```
