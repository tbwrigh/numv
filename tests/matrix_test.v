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