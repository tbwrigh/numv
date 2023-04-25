module main

import numv

mut m := numv.fill_matrix([1.0,2.0,3.0,4.0],[5.0,6.0,7.0,8.0],[9.0,10.0,11.0,12.0],[13.0,14.0,15.0,16.0])!

println("A:")
m.print()
println("")

mut n := m.copy()

println("B:")
n.print()
println("")

mut prod := numv.mul(m,n)!

println("A * B = ")
prod.print()
println("")

mut d := numv.fill_matrix([4.0,3.0],[6.0,1.0])!

println("d:")
d.print()
println("")

println("determinant of d:")
println(d.determinant()!)
println("")

mut d_inv := numv.invert_matrix(d)!

println("inverse of d:")
d_inv.print()
println("")

// mut mt := m.copy()
// mt.transpose()
// mt.print()
// println("")

// println(m.determinant()!)
// println("")

// mut mi := numv.invert_matrix(m)!
// mi.print()