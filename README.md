# Synology Development Environment

This is a container-based development environment intended for compiling SPK packages for Synology devices.

The environment is managed using Docker and Docker Compose _(see [`docker-compose.yml`](./docker-compose.yml))_.<br />
There are also several helper commands defined in the [`Makefile`](./Makefile).

## Getting started

#### Prepare the environment

Start the Docker development container environment:

```sh
make dev
```

Initialize a terminal session within the container:

```sh
make shell
```

Clone the Synology development tools:

```sh
git clone https://github.com/SynologyOpenSource/pkgscripts-ng.git /data/toolkit/pkgscripts-ng
```

> <br />_ℹ️ You will need to know the architecture of your Synology device. Refer to the [Synology documentation](https://kb.synology.com/en-me/DSM/tutorial/What_kind_of_CPU_does_my_NAS_have) to find yours._<br />&nbsp;

Deploy the development environment for your target DSM version and device architecture:

```sh
# Move to the developer tools directory
cd /data/toolkit/pkgscripts-ng

# Checkout the version tag for your target DSM version
git checkout DSM7.2

# Optionally, see the available target architectures for your target DSM version
/data/toolkit/pkgscripts-ng/EnvDeploy -v 7.2 -l

# Deploy the target architecture for your target DSM version
# (this will take some time - if it fails, try running again)
/data/toolkit/pkgscripts-ng/EnvDeploy -v 7.2 -p apollolake
```

## Compiling packages

I have included an [example for building `vim`](./templates/vim/synology/README.md).<br />
Refer to the [Synology documentation](https://help.synology.com/developer-guide/getting_started/first_package.html) for more on building packages.

## Resources

-   [Synology package documentation](https://help.synology.com/developer-guide/getting_started/gettingstarted.html)
