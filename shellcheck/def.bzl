load("@rules_shellcheck//shellcheck/rules:shellcheck.bzl", _shellcheck_test = "shellcheck_test")

BZL_FILES = [
    "**/*.bazel",
    "**/WORKSPACE*",
    "**/BUILD",
]

def shellcheck_test(name, srcs, tags, size="small"):
    _shellcheck_test(
        name = name,
        srcs = srcs,
        size = size,
        tags = tags,
        visibility = ["//visibility:public"],
    )
