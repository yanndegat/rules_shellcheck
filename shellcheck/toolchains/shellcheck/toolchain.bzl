ShellcheckInfo = provider(
    doc = "Information about how to invoke Shellcheck.",
    fields = ["shellcheck"],
)

def _shellcheck_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        runtime = ShellcheckInfo(
            shellcheck = ctx.file.shellcheck,
        ),
    )
    return [toolchain_info]

shellcheck_toolchain = rule(
    implementation = _shellcheck_toolchain_impl,
    attrs = {
        "shellcheck": attr.label(
            mandatory = True,
            allow_single_file = True,
            executable = True,
            cfg = "target",
        ),
    },
)

def register_shellcheck_toolchain(visibility):
    toolchain_typename = "toolchain_type"
    native.toolchain_type(
        name = toolchain_typename,
        visibility = visibility,
    )

    name = "linux_amd64"
    toolchain_name = "{}_toolchain".format(name)

    shellcheck_toolchain(
        name = "{}_impl".format(name),
        shellcheck = "@shellcheck//:runtime",
    )

    native.toolchain(
        name = toolchain_name,
        exec_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
        target_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
        toolchain = ":{}_impl".format(name),
        toolchain_type = ":{}".format(toolchain_typename),
        visibility = visibility,
    )


def _download_impl(ctx):
    ctx.report_progress("Downloading shellcheck")

    ctx.template(
        "BUILD",
        Label("@rules_shellcheck//shellcheck/toolchains/shellcheck:BUILD.toolchain.tpl"),
        executable = False,
    )

    url_template = "https://github.com/koalaman/shellcheck/releases/download/v{version}/shellcheck-v{version}.{os}.{arch}.tar.xz"
    url = url_template.format(version = ctx.attr.version, os = ctx.attr.os, arch = ctx.attr.arch)

    ctx.download_and_extract(
        url = url,
        sha256 = ctx.attr.sha256,
        stripPrefix = "shellcheck-v" + ctx.attr.version,
        output = "shellcheck",
    )

    return {
        "version": ctx.attr.version,
        "sha256": ctx.attr.sha256,
    }

shellcheck_download = repository_rule(
    implementation = _download_impl,
    attrs = {
        "version": attr.string(mandatory = True),
        "sha256": attr.string(mandatory = True),
        "os": attr.string(mandatory = True),
        "arch": attr.string(mandatory = True),
    },
)
