# cpprandom [![CI](https://github.com/diku-dk/cpprandom/workflows/CI/badge.svg)](https://github.com/diku-dk/cpprandom/actions) [![Documentation](https://futhark-lang.org/pkgs/github.com/diku-dk/cpprandom/status.svg)](https://futhark-lang.org/pkgs/github.com/diku-dk/cpprandom/latest/)

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
> (d.rand (1,6) rng).1
1
```

## Compatibility

The versioning guarantees for this package do not necessarily involve
full replicability.  The random sequences may change, even without
bumping the major version number, if necessary to fix bugs in seeding
or to improve operations such as `split_rng`.

## Performance

The three fastest predefined RNGs are `minstd_rand` (and its cousin
`minstd_rand0`), `xorshift128plus`, and `pcg32`.  A [simple benchmark
program](benchmark.fut) gives the following results on an AMD Vega 64
GPU:

```
$ futhark bench --backend=opencl benchmark.fut
Compiling benchmark.fut...
Results for benchmark.fut:minstd_rand:
dataset #0 ("128000i32 10000i32"):    5986.30μs (avg. of 10 runs; RSD: 0.06)
Results for benchmark.fut:pcg32:
dataset #0 ("128000i32 10000i32"):    9617.80μs (avg. of 10 runs; RSD: 0.11)
Results for benchmark.fut:xorshift128plus:
dataset #0 ("128000i32 10000i32"):   12447.70μs (avg. of 10 runs; RSD: 0.02)
```

Note that the randomness produced by `minstd_rand` is much worse than
what is produced by the alternatives.
