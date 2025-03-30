# Josh's Archive of Old Programming

This repository is an archive and chronicle of my old programming throughout the years,
*before* I started doing it as a career!

There are generally 3 epochs in my amateur programming life: young childhood, high school,
and college.  These are uniquely broken out by language used at that time.

## BASIC

Starting around age 8-14 (1987-1993), I primarily dabbled with [Applesoft BASIC] on an
[Apple IIe].

I have old floppies with a bunch of BASIC programs. Restoration of the disks has not been
attempted yet! 😬

## Pascal

In sophomore through senior grades in high school, I took programming classes that
featured [Pascal] on [PS/2] computers using [Turbo Pascal] 7.

### Installing and Running Turbo Pascal

Since I originally wrote my code on Turbo Pascal 7 in DOS, I suggest trying to compile and
run the code in Turbo Pascal 7 within DOSBox, but specifically you should use
[dosbox-staging], which is a more modern implementation of DOSBox. If you have [Homebrew]
installed, the installer will offer to install [dosbox-staging] automatically.

Turbo Pascal 7 is now freely available as [abandonware] at:
[Borland Turbo Pascal 7.x](https://winworldpc.com/product/turbo-pascal/7x). Download the
archive and expand it. Inside you'll find disk images that the installer can mount to do
the installation.

Run [install-tp.sh](./install-tp.sh), passing it the paths to the disk images. For
instance:

```sh
./install-tp.sh /path/to/images/*.img
```

You can then use [tp.sh](./tp.sh) to start up a DOSBox environment that runs Turbo Pascal.

## C/C++

In college, I took classes in C/C++, Visual Basic, RPG, COBOL, HTML, and more. But the
most memorable by far was C/C++. We used [Turbo C++] 3.0 for DOS primarily. This was the
perfect transition from my Turbo Pascal 7 experience in high school, and set the foundation
for my love of C-like languages.

### Installing and Running Turbo C++

Since I originally wrote my code on Turbo C++ 3 in DOS, I suggest trying to compile and run
the code in Turbo C++ within DOSBox, but specifically you should use [dosbox-staging],
which is a more modern implementation of DOSBox. If you have [Homebrew] installed, the
installer will offer to install [dosbox-staging] automatically.

Turbo C++ 3 for DOS is now freely available as [abandonware] at:
[Borland Turbo C++ 3.x (DOS)](https://winworldpc.com/product/turbo-c/3x). Download the
archive and expand it. Inside you'll find disk images that the installer can mount to do
the installation.

Run [install-tc.sh](./install-tc.sh), passing it the paths to the disk images. For
instance:

```sh
./install-tc.sh /path/to/images/*.img
```

You can then use [tc.sh](./tc.sh) to start up a DOSBox environment that runs Turbo C++ 3.

[Abandonware]: https://en.wikipedia.org/wiki/Abandonware
[Apple IIe]: https://en.wikipedia.org/wiki/Apple_IIe
[Applesoft BASIC]: https://en.wikipedia.org/wiki/Applesoft_BASIC
[dosbox-staging]: https://www.dosbox-staging.org
[Homebrew]: https://brew.sh
[Pascal]: https://en.wikipedia.org/wiki/Pascal_(programming_language)
[PS/2]: https://en.wikipedia.org/wiki/IBM_Personal_System/2
[Turbo C++]: https://en.wikipedia.org/wiki/Turbo_C%2B%2B
[Turbo Pascal]: https://en.wikipedia.org/wiki/Turbo_Pascal
