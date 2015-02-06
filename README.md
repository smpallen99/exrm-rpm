# Elixir Release Manager RPM Generator

Adds simple [Red Hat Package Manager](http://en.wikipedia.org/wiki/RPM_Package_Manager) (RPM) generation to the exrm package manager. 

## Usage

You can build an rpm at the same time as building a release by adding the `--rpm` option to `release`

- `mix release --rpm`

This task first constructs the release using `exrm`, then generates an rpm file for the release. The rpm is build using
default spec file and init script templates. If you would like to customize the templates, you can first run `the release.copy_rpm_templates`
task.

- `mix release.copy_rpm_templates`

To see what flags can be passed, use `mix help release.copy_rpm_templates`.

The `_build/rpm` directory tree, along with the rest of the release with `mix release.clean`

Please visit [exrm](https://github.com/bitwalker/exrm) for additional information. 

## Getting Started

This project's goal is to make building a rpm for an Elixir release very simple, by adding the rpm features to the exrm project. To get started:

#### Add exrm_rpm as a dependency to your project
```elixir
  defp deps do
    [{:exrm_rpm, "~> 0.3.0"}]
  end
```

#### Fetch and Compile

- `mix deps.get`
- `mix deps.compile`

#### Perform a release and build a rpm

- `mix release --rpm`

#### Copy the rpm to your target system and install

```
> scp rel/test/releases/0.0.1/test-0.0.1-0.x86_64.rpm me@example.com:/tmp/
> ssh me@example.com
> rpm -i /tmp/test-0.0.1-0.x86_64.rpm
```

#### Manage the service on your target system

```
> service test status
> service test stop
> service test restart
```

## Customizing the rpm

### Setting the rpm's summary and description meta data

Edit your projects `config/config.exs` file
```elixir
[
  test: [
    summary: "An example rpm build project ...",
    description: """
    This is the description of my test project. 
    Use it wisely...
    """,
  ]
]
```

### Customizing the spec file and init script templates

Copy the templates with:

`mix release.copy_rpm_templates`

Now edit the spec template in your favorite text editor

`vim rpm/templates/spec`

You can also edit the init script template

`vim rpm/templates/init_script`

The next time you run `mix release --rpm`, it will use the custom templates.

> Lack of support for a mix task to remove custom templates is deliberate. Once created, 
> these files are considered part of your projects source code and should be managed appropriately.

### Add additional installation files

If your application requires additional installation files, create a new `sources` directory under the `rpm` directory.

`mkdir rpm/sources`

Add the additional files into this directory. They will be copied into the build 'SOURCES' directory prior to running rpm-build.

Finally, add the new sources in the spec template and the appropriate spec file logic to process the additional files.

## Additional Notes

- The generated rpm installs the following
    - the release in `/usr/local/app_name`
    - an init.d script to manage the service

- During the rpm build process, the following directory tree and files are created:
    - `_build/rpm/SPECS/name.spec` - the generated spec file used to build the rpm
    - `_build/rpm/SOURCES/name` - the generated init script included in the rpm
    - `rel/name/releases/version/name-version-arch.rpm` - the generated rpm

## Import Links

- [RPM Package Manager](http://en.wikipedia.org/wiki/RPM_Package_Manager)
- [exrm-rpm on Hex.pm](https://hex.pm/packages/exrm_rpm)
- [How to create an rpm](https://fedoraproject.org/wiki/How_to_create_an_RPM_package)

## Acknowledgements

- Thanks to @bitwalker for the exrm plugin capabilities and all his help.

## Feedback

This project was built based on my experience building RPMs for E-MetroTels's products. 
I welcome input from others.

## License

exrm_rpm is copyright (c) 2014 E-MetroTel. 

The source code is released under the MIT License.

Check [LICENSE](LICENSE) for more information.
