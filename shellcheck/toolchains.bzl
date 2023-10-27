load("@rules_shellcheck//shellcheck/toolchains/shellcheck:toolchain.bzl", "register_shellcheck_toolchain")

def register_toolchains():
    register_shellcheck_toolchain(visibility = ["//visibility:public"])
