# cpprandom [![Build Status](https://travis-ci.org/diku-dk/cpprandom.svg?branch=master)](https://travis-ci.org/diku-dk/cpprandom) [![Documentation](https://futhark-lang.org/pkgs/github.com/diku-dk/cpprandom/status.svg)](https://futhark-lang.org/pkgs/github.com/diku-dk/cpprandom/latest/)

This package provides random number generation for Futhark.  It is
designed to closely imitate
[`<random>`](http://www.cplusplus.com/reference/random/), which is
very elaborate, but also very flexible.  Another complication is due
to Futhark's purity, so it is up to the programmer to explicitly
manage the RNG state.  You are adviced to read the documentation
(which contains examples) before using this package.  The
[tests](lib/github.com/diku-dk/cpprandom/random_tests.fut) may also be
illuminating.

## Installation

```
$ futhark pkg add github.com/diku-dk/cpprandom
$ futhark pkg sync
```

## Usage

The following shows how to combine the random number engine
`minstd_rand` with the distribution module `uniform_int_distribution`
to simulate a single dice roll (throwing away the new RNG state).

```
$ futhark repl
> import "lib/github.com/diku-dk/cpprandom/random"
> let rng = minstd_rand.rng_from_seed [123]
> module d = uniform_int_distribution i32 minstd_rand
> (d.rand (1,6) rng).2
1
```

## Compatibility

The versioning guarantees for this package do not necessarily involve
full replicability.  The random sequences may change, even without
bumping the major version number, if necessary to fix bugs in seeding
or to operations such as `split_rng`.
