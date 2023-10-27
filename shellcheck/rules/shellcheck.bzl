def _impl_test(ctx):
    runtime = ctx.toolchains["@rules_shellcheck//:toolchain_type"].runtime

    if len(ctx.files.srcs) == 0:
        fail("shellcheck_test srcs must contain at least one file.")

    runfiles = [runtime.shellcheck] + ctx.files.srcs
    cmd = "{shellcheck} {opts} {files}".format(
        shellcheck = runtime.shellcheck.path,
        opts = " ".join(ctx.attr.opts),
        files = " ".join([f.short_path for f in ctx.files.srcs]),
    )

    ctx.actions.write(
        output = ctx.outputs.executable,
        content = cmd,
    )

    return [
        DefaultInfo(
            executable = ctx.outputs.executable,
            runfiles = ctx.runfiles(files = runfiles),
        ),
    ]

shellcheck_test = rule(
    implementation = _impl_test,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
        ),
        "opts": attr.string_list( default = ["-s", "bash", "-x"]),
    },
    toolchains = ["@rules_shellcheck//:toolchain_type"],
    test = True,
)
