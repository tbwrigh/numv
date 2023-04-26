import numv

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