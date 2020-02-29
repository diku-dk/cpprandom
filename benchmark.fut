import "lib/github.com/diku-dk/cpprandom/random"

module mk_bench (E: rng_engine) : {
  val bench : (n: i32) -> (m: i32) -> [n]E.int.t
} = {
  let bench (n: i32) (m: i32) =
    let sum_stream (i: i32) =
      let rng = E.rng_from_seed [i ^ 123]
      let acc = E.int.i32 0
      let (_, acc) = loop (rng, acc) = (rng, acc) for _i < m do
                     let (rng, x) = E.rand rng
                     in (rng, E.int.(acc + x))
      in acc
    in tabulate n sum_stream
}

module minstd_rand_bench = mk_bench minstd_rand
entry minstd_rand = minstd_rand_bench.bench

module pcg32_bench = mk_bench pcg32
entry pcg32 = pcg32_bench.bench

module xorshift128plus_bench = mk_bench xorshift128plus
entry xorshift128plus = xorshift128plus_bench.bench

-- ==
-- entry: minstd_rand pcg32 xorshift128plus
-- compiled input { 128000 10000 }
