package(default_visibility = ["//visibility:public"])

filegroup(
    name = "runtime",
    srcs = ["shellcheck/shellcheck"],
    visibility = ["//visibility:public"]
)
