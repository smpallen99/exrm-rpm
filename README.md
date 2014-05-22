# Elixir Release Manager RPM Generator Plug-in

## Usage

You can build an rpm at the same time as building a release by adding the `--rpm` option to `release`

- `mix release --rpm`

This task first constructs the release using `exrm`, then generates an rpm file for the release. The rpm is build using
default spec file and init script templates. If you would like to customize the templates, you can first run `the release.copy_rpm_templates`
task.

- `mix release.copy_rpm_templates`

To see what flags can be passed, use `mix help release.copy_rpm_templates`.

## Getting Started

This project's goal is to make building a rpm for an Elixir release very simple, by adding the rpm features to the exrm project. To get started:

#### Add exrm_rpm as a dependency to your project
```elixir
  defp deps do
    [{:exrm_rpm, "~> 0.1.0"}]
  end
```

#### Fetch and Compile

- `mix deps.get`
- `mix deps.compile`

#### Perform a release and rpm build

- `mix release --rpm`

#### Copy the rpm to your target system and install

```
> scp _build/rpm/RPMS/x86_64/test-0.0.1-0.tar.gz me@example.com:/tmp/
> ssh me@example.com
> rpm -i /tmp/test-0.0.1-0.tar.gz
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

## The details

#### The generated rpm installs the following

- the release in `/usr/local/app_name`
- an init.d script to manage the service

#### During the rpm build process, the following directory tree and files are created:

- _build/rpm/SPECS/name.spec      # the generated spec file used to build the rpm
- _build/rpm/SOURCES/name         # the generated init script included in the rpm
- _build/rpm/RPMS/x86_64/name-version-x86_64.rpm  # the generated rpm

## TODO

1. Add clean support
2. Add more configuration options to config.exs (build_arch, rpmbuild, etc.)
3. Move the generated rpm the rel directory
4. Create the correct _build/rpm/RPMS/arch folders 
4. More testing
5. Get feedback

