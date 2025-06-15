import "lib/github.com/diku-dk/cpprandom/random"
import "lib/github.com/diku-dk/cpprandom/romu"

module mk_bench (I: integral) (E: rng_engine with t = I.t) = {
  def stream (n: i64) =
    let rng = E.rng_from_seed [123]
    let out = replicate n (I.i64 0)
    in (loop (rng, out) for i < n do
          let (rng, x) = E.rand rng
          in (rng, out with [i] = x)).1

  def bench (n: i64) (m: i64) =
    let sum_stream (i: i64) =
      let rng = E.rng_from_seed [i32.i64 (i ^ 123)]
      let acc = I.i64 0
      let (_, acc) =
        loop (rng, acc) = (rng, acc)
        for _i < m do
          let (rng, x) = E.rand rng
          in (rng, I.(acc + x))
      in acc
    in tabulate n sum_stream
}

module minstd_rand_bench = mk_bench u32 minstd_rand
entry minstd_rand = minstd_rand_bench.bench

module pcg32_bench = mk_bench u32 pcg32
entry pcg32 = pcg32_bench.bench

module xorshift128plus_bench = mk_bench u64 xorshift128plus
entry xorshift128plus = xorshift128plus_bench.bench

module romu_quad_bench = mk_bench u64 romu_quad
entry romu_quad = romu_quad_bench.bench

module romu_trio_bench = mk_bench u64 romu_trio
entry romu_trio = romu_trio_bench.bench

module romu_duo_bench = mk_bench u64 romu_duo
entry romu_duo = romu_duo_bench.bench

module romu_duo_jr_bench = mk_bench u64 romu_duo_jr
entry romu_duo_jr = romu_duo_jr_bench.bench

module romu_quad32_bench = mk_bench u32 romu_quad32
entry romu_quad32 = romu_quad32_bench.bench

module romu_trio32_bench = mk_bench u32 romu_trio32
entry romu_trio32 = romu_trio32_bench.bench

module romu_mono32_bench = mk_bench u16 romu_mono32
entry romu_mono32 = romu_mono32_bench.bench

-- ==
-- entry: minstd_rand pcg32 xorshift128plus romu_quad romu_trio romu_duo romu_duo_jr romu_quad32 romu_trio32 romu_mono32
-- compiled input { 128000i64 10000i64 }
