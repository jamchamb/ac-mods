# Animal Crossing "Hello World" with C

This requires the devkitPro tools to build.
See <https://devkitpro.org/wiki/Getting_Started> for how to install `devkitpro` and `gamecube-dev`.

## Building

With `gamecube-dev` installed, just run `make`. The output will include a `.patch` file that holds the generated code to patch in.

### Generating the GameCube save file

[`ac-nesrom-gen`](https://github.com/jamchamb/ac-nesrom-save-generator)
can automatically create a GCI file for the mod patches by reading the
`gci_build.yaml` config file. If installed, the GCI file will be generated
when running `make`.

Alternatively, use this command:

```console
$ ac-nesrom-gen --autoheader 80002000 "Mod Name" input.patch output.gci
```

Import the GCI save file to a memory card and use the generic NES Console
item to load the mod.

## Development

### Specifying patch location

Set the start address for the patch in `linker.ld` just before
the `.text` section.

Note that `*(.text.__entry);` must always be the first entry in the `.text`
section of the linker script.

### Calling Animal Crossing functions

Here are a couple of ways to call a function that already exists in
Animal Crossing:

#### Use function pointers

Define the function like this, using its address as the pointer value:

```c
void (*OSReport)(char*, ...) = (void*) 0x8005A750;
```

#### Use the linker script

This uses fewer instructions, resulting in a smaller patch size.

1. Define the function like this:

   ```
   extern void OSReport(char*, ...);
   ```
2. Define its location in `linker.ld`:

   ```
   SECTIONS
   {
           . = 0x80002000;
           .text . : {
               ...
           }
           ...
           OSReport = 0x8005A750;
   }
   ```
