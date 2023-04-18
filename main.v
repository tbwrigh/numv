module main

import numv

mut a := [1.0,2.0]
mut b := [3.0,4.0]
mut m := numv.fill_matrix(a,b)

mut c := [1.0,2.0]
mut d := [3.0,4.0]
mut n := numv.fill_matrix(c,d)

mut p := numv.mul(m,n)

p.print()

mut ms := numv.apply(m, fn (n f64) f64 {
	return n*n
})
ms.print()
m.print()

println("")

print(m.determinant())

println("")