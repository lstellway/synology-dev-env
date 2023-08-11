# Building VIM for Synology

> <br />_ℹ️ Before starting, ensure you have prepared the build environment for your target device as outlined in the [README](../../../README.md)._<br />&nbsp;

Initialize a terminal session within the container:

```sh
make shell
```

Clone the VIM git repository into the `source` directory`:

```sh
git clone https://github.com/vim/vim.git /data/toolkit/source/vim
```

Copy the Synology template files for VIM:

```sh
cp -R /data/templates/vim/. /data/toolkit/source/vim
```

Compile the package for your target environment:

```sh
# Specify the package directory name under the `source` directory for the `-c` option
/data/toolkit/pkgscripts-ng/PkgCreate.py -v 7.2 -p apollolake -c vim
```

> <br />ℹ️ _If things fail, check the `logs` directory under the related environment directory under `/data/toolkit/build_env`._<br />&nbsp;

If all goes well, you should now have a new folder under `/data/toolkit/result_spk`.<br />
You can exit the container and copy these locally with a helper command:

```sh
make copy-results
```

## Install SPK

Login to DSM on your Synology device and upload and install the related `.spk` file.

> <br />_ℹ️ DSM may warn you of a 3rd party developer. This is okay._<br />&nbsp;

## Gotchas

If you `ssh` into your Synology device, `which vim` may show another path, such as `/bin/vim`.<br />
To address this in a non-destructive way, I created an `_archive` directory in the `/bin` dir and moved the file there:

```sh
mkdir /bin/_archive
mv /bin/vim /bin/_archive
```

Running `which vim` should now show the expected path of `/usr/local/bin/vim`.<br />

> <br />_ℹ️ You may need to log out and back in for the updated `vim` location to register._<br />&nbsp;

In my experience, I received an error while running the `vim` command at this point:

> <br />_/usr/local/bin/vim: error while loading shared libraries: libncursesw.so.5: cannot open shared object file: No such file or directory_<br />&nbsp;

In order to fix, I needed to copy over and symlink several library files from my build environment container directory _(eg. `/data/toolkit/build_env/ds.apollolake-7.2/usr/lib`)_ to the `/usr/lib` directory on the Synology device.

-   `libncursesw.so.5.9`
-   `libgpm.so.2.1.0`
-   `libacl.so.1.1.0`
-   `libsodium.so.23.3.0`

After this, I was up and running!
