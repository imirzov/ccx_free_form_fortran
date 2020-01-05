© Ihor Mirzov, January 2020  
Distributed under GNU General Public License v3.0  
Libraries ARPACK and SPOOLES have their own licenses

<br/><br/>



---

[Downloads](#downloads) |
[How to use](#how-to-use) |
[Screenshots](#screenshots) |
[Your help](#your-help)

---

<br/><br/>



# Fortran code converter for CalculiX 2.16

Converts old CalculiX Fortran 77 code to the one with free form. Shifts comments and continuation marks for better code folding. Compiles all Fortran sources with *-ffree-form* flag. Takes files to be compiled from *Makefile.inc*. To understand the difference in sources see [screenshots](#screenshots).

The script has already converted sources from folder *ccx_2.16* and put them into:

- ccx_linux/ccx_2.16_ffree_form
- ccx_windows/ccx_2.16_ffree_form

Also those folders include compiled ARPACK and SPOOLES libraries.

Converted CalculiX sources are compiled and built with Makefile_MT:

- ccx_linux/ccx_2.16_ffree_form/ccx_2.16_MT
- ccx_windows/ccx_2.16_ffree_form/ccx_2.16_MT.exe

<br/><br/>



# Downloads

Release version of binaries, converted and compiled sources together with original code could be found on [the releases page](https://github.com/imirzov/ccx_free_form_fortran/releases).

<br/><br/>



# How to use

Default usage of the converter is:

    python3 free_form_fortran.py

Also you can explicitly point existing folders to process:

    python3 free_form_fortran.py original_sources_dir converted_sources_dir

<br/><br/>



# Screenshots

Before conversion:  
![before conversion](img_original.png "before conversion")

After conversion - code folding works like a charm:  
![after conversion](img_converted.png "after conversion")

<br/><br/>



# Your help

- Simply use this software and ask questions.
- Report problems by [posting issues](https://github.com/imirzov/ccx_free_form_fortran/issues).
