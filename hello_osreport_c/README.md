# Animal Crossing hello world with C

This requires the devkitPro tools to build.
See <https://devkitpro.org/wiki/Getting_Started> for how to install `devkitpro` and `gamecube-dev`.

## Building

With `gamecube-dev` installed, just run `make`. The output will include a `.patch` file that holds the generated code to patch in.

### Generating the GameCube save file

[`patcher.py`](https://github.com/jamchamb/ac-nesrom-save-generator) can automatically create
a GCI file for the `.patch` file with these arguments:

```console
$ ./patcher.py --autoheader 80002000 --loader "Mod Name" input.patch output.gci
```

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
