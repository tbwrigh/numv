import numv

import math

fn test_matrix_equality() {
	m := numv.fill_matrix([1.0,2.0],[3.0,4.0])!

	assert m.equals(m.copy())

	n := numv.fill_matrix([1.0,2.0],[3.0,4.0])!

	assert m.equals(n)
	assert n.equals(m)

	i := numv.identity(2)

	assert m.equals(i)==false

	k := numv.fill_matrix([1.0,2.0,5.0],[3.0,4.0,6.0])!

	assert m.equals(k)==false
}

fn test_matrix_mul_simple() {
	m := numv.fill_matrix([1.0,2.0],[3.0,4.0])!
	n := m.copy()

	r1 := numv.mul(m,n)!
	er1 := numv.fill_matrix([7.0,10.0],[15.0,22.0])!

	assert r1.equals(er1)
	assert er1.equals(r1)
}

fn test_matrix_mul_complex() {
	m := numv.fill_matrix([2.0,1.0,3.0,4.0],[0.25,0.5,0.33,0.75],[2.5,1.5,3.25,4.75])!
	n := numv.fill_matrix([1.33,2.25],[3.125,4.25],[4.5,0.75],[2.33,4.75])!

	r1 := numv.mul(m,n)!
	er1 := numv.fill_matrix([28.605, 30.0],[5.1275, 6.4975], [33.705, 37.0])!

	assert r1.equals_tol(er1, 4)
}

fn test_apply() {
	mut m := numv.identity(3)
	m.apply(fn(i f64) f64 {return 2.0 * i})
	er1 := numv.fill_matrix([2.0,0.0,0.0],[0.0,2.0,0.0],[0.0,0.0,2.0])!
	assert m.equals(er1)
	m.apply(fn(i f64) f64 {return i*i*i})
	er2 := numv.fill_matrix([8.0,0.0,0.0],[0.0,8.0,0.0],[0.0,0.0,8.0])!
	assert m.equals(er2)
}

fn test_determinant() {
	m := numv.fill_matrix([4.0,7.0,9.0],[2.0,5.0,8.0],[1.0,3.0,6.0])!
	assert 5.0 == math.round_sig(m.determinant()!, 3)
}

fn test_inverse() {
	m := numv.fill_matrix([4.0,7.0,9.0],[2.0,5.0,8.0],[1.0,3.0,6.0])!
	r1 := numv.invert_matrix(m)!
	er1 := numv.fill_matrix([1.2,-3.0,2.2],[-0.8,3.0,-2.8],[0.2,-1.0,1.2])!

	assert r1.equals_tol(er1, 7)

	r2 := numv.invert_matrix(r1)!
	
	assert m.equals_tol(r2, 7)

	prod := numv.mul(m,r1)!
	er3 := numv.identity(3)
	
	assert prod.equals_tol(er3, 7)
}

fn test_transpose() {
	m := numv.fill_matrix([1.0,2.0],[3.0,4.0])!
	r1 := numv.transpose(m)
	er1 := numv.fill_matrix([1.0,3.0],[2.0,4.0])!

	assert r1.equals(er1)

	n := numv.fill_matrix([1.0,2.0,3.0],[4.0,5.0,6.0])!
	r2 := numv.transpose(n)
	er2 := numv.fill_matrix([1.0,4.0],[2.0,5.0],[3.0,6.0])!

	assert r2.equals(er2)
}

fn test_add_sub_scalarmul() {
	m := numv.fill_matrix([1.0,2.0],[3.0,4.0])!
	n := numv.fill_matrix([0.0,1.0],[2.0,3.0])!

	r1 := numv.sub(m,n)!
	er1 := numv.fill_matrix([1.0,1.0],[1.0,1.0])!

	assert r1.equals(er1)

	r2 := numv.add(r1, n)!

	assert m.equals(r2)

	r3 := numv.scalar_mul(m, 3)
	er3 := numv.fill_matrix([3.0,6.0],[9.0,12.0])!
}