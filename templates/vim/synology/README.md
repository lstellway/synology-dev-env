# Building

- Clone the VIM git repository
- Copy the Synology build files
- Downlaod the generated SPK files
- Install the SPK
  - DSM will warn you of a 3rd party developer

Running VIM shows error:

```
/usr/local/bin/vim: error while loading shared libraries: libncursesw.so.5: cannot open shared object file: No such file or directory
```

I was able to copy over the following missing libraries to `/usr/lib` from the chroot environment:

- libncursesw.so.5.9
- libgpm.so.2.1.0
- libacl.so.1.1.0
- libsodium.so.23.3.0

