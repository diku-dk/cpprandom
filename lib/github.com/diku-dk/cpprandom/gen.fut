-- | Random value generation.

import "random"

module type gen = {
  -- | A generator for values of type t.
  type^ gen 't

  -- | An RNG state used for generating values.
  type rng

  -- | Generate a random value from a generator.
  val generate 't : rng -> gen t -> (rng, t)

  -- | Apply function to result of generator.
  val fmap 'a 'b : (a -> b) -> gen a -> gen b

  val i8 : gen i8
  val i16 : gen i16
  val i32 : gen i32
  val i64 : gen i64

  val u8 : gen u8
  val u16 : gen u16
  val u32 : gen u32
  val u64 : gen u64

  -- | Generates numbers in range (-1,1).
  val f16 : gen f16

  -- | Generates numbers in range (-1,1).
  val f32 : gen f32

  -- | Generates numbers in range (-1,1).
  val f64 : gen f64

  val pair 'a 'b : gen a -> gen b -> gen (a, b)
  val arr 'a : (n: i64) -> gen a -> gen ([n]a)
}

module mk_gen (E: rng_engine) : gen with rng = E.rng = {
  type rng = E.rng
  type^ gen 't = E.rng -> (E.rng, t)

  def generate rng gen = gen rng

  def fmap f gen rng =
    let (rng, x) = gen rng
    in (rng, f x)

  module i8_dist = uniform_int_distribution i8 E
  module i16_dist = uniform_int_distribution i16 E
  module i32_dist = uniform_int_distribution i32 E
  module i64_dist = uniform_int_distribution i64 E

  module u8_dist = uniform_int_distribution u8 E
  module u16_dist = uniform_int_distribution u16 E
  module u32_dist = uniform_int_distribution u32 E
  module u64_dist = uniform_int_distribution u64 E

  module f16_dist = uniform_real_distribution f16 E
  module f32_dist = uniform_real_distribution f32 E
  module f64_dist = uniform_real_distribution f64 E

  def i8 = i8_dist.rand (i8.lowest, i8.highest)
  def i16 = i16_dist.rand (i16.lowest, i16.highest)
  def i32 = i32_dist.rand (i32.lowest, i32.highest)
  def i64 = i64_dist.rand (i64.lowest, i64.highest)

  def u8 = u8_dist.rand (u8.lowest, u8.highest)
  def u16 = u16_dist.rand (u16.lowest, u16.highest)
  def u32 = u32_dist.rand (u32.lowest, u32.highest)
  def u64 = u64_dist.rand (u64.lowest, u64.highest)

  def f16 = f16_dist.rand (-1, 1)
  def f32 = f32_dist.rand (-1, 1)
  def f64 = f64_dist.rand (-1, 1)

  def pair f g rng =
    let (rng, x) = f rng
    let (rng, y) = g rng
    in (rng, (x, y))

  def arr n f rng =
    E.split_rng n rng
    |> map f
    |> unzip
    |> \(rngs, xs) -> (E.join_rng rngs, xs)
}

module RNG = xorshift128plus
module G = mk_gen RNG

def random_matrix (size: i64) : [][]f64 =
  let rng = RNG.rng_from_seed [i32.i64 size, 1, 2, 3]
  let size = G.fmap (\x -> 1 + (i64.abs x) % size) G.i64
  let (rng, (n, m)) = G.generate rng (G.pair size size)
  let (_, M) = G.generate rng (G.arr (n * m) G.f64)
  in unflatten M
