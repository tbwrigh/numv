module numv

// this is currently only used for round_sig 
// potentially consider removing this and writing a round function
import math

// matrix struct stores matrix as a list of numbers with rows and columns defined
// advantage of 1d array for matrix is minimizing the number of load operations 
pub struct Matrix {
pub mut:
	rows int
	cols int
	mat []f64
}

// just is a method to make a matrix given specified input
pub fn generate_matrix(rows int, cols int, mx []f64) Matrix {
	// TODO refactor existing code such that this method can throw error for improper matrix building

	return Matrix{
		rows : rows
		cols: cols
		mat: mx
	}
}

// creates a deep copy of a Matrix
pub fn (m Matrix) copy() Matrix {
	mut r := m.rows
	mut c := m.cols
	mut ele := r * c 
	mut mx := []f64
	for entry in m.mat {
		mx << entry
	}
	return generate_matrix(r,c,mx)
}

// given some set of arrays of nums, make a matrix
pub fn fill_matrix(rows ...[]f64) !Matrix {
	mut r := 0
	mut c := 0
	mut wc := 0
	mut mx := []f64

	for row in rows {
		for entry in row {
			mx << entry
		}
		r++
		c = row.len

		// this sets the initial column 
		// TODO there may be an edge case that can cause an error here
		if row.len != 0 && wc == 0 {
			wc = c
		}

		// return an error if the row length changes 
		if wc != c {
			return error("Column len varies")
		}
	}

	return generate_matrix(r, c, mx)

}

// makes a matrix of specified size filled with zeros
pub fn zeroes(rows int, cols int) Matrix {
	mut mx := []f64
	for row in 0..(rows*cols) {
		mx << 0
	}
	return generate_matrix(rows, cols, mx)
}

// makes an nxn identity matrix
pub fn identity(dim int) Matrix {
	mut rows := dim
	mut cols := dim
	mut mx := []f64
	// TODO this can be simplified to a non nested loop using int division and modulo
	for row in 0..rows {
		for col in 0..cols {
			if row == col {
				mx << 1
			}else {
				mx << 0
			}
		}
	}

	return generate_matrix(rows, cols, mx)
}

// check exact equality of 2 matrices
pub fn (m Matrix) equals(mo Matrix) bool {
	if m.rows != mo.rows || m.cols != mo.cols {
		return false
	}

	for i in 0..(m.rows * m.cols) {
		if m.mat[i] != mo.mat[i] {
			return false
		}
	}

	return true
}

// this checks approximate equality of 2 matrices rounding to n specified decimal places
pub fn (m Matrix) equals_tol(mo Matrix, tol int) bool {

	if m.rows != mo.rows || m.cols != mo.cols {
		return false
	}

	for i in 0..(m.rows * m.cols) {
		if math.round_sig(m.mat[i], tol) != math.round_sig(mo.mat[i], tol) {
			return false
		}
	}

	return true
}

// prints the matrix nicely
// TODO work on defining some pretty printing system for consistency amongst nums of varying decimal lengths
pub fn (m Matrix) print() {
	for i in 0..m.rows {
		for j in 0..m.cols {
			print(m.mat[i * m.cols + j])
			print(" ")
		}
		println("")
	}
}

// multiply matrix mo by matrix mt
pub fn mul(mo Matrix, mt Matrix) !Matrix {
	if mo.cols != mt.rows {
		return error("Matrices cannot be multiplied. Incorrent Dimensions.")
	}

	mut rows := mo.rows
	mut cols := mt.cols

	mut n := mo.cols

	mut mx := []f64

	for row in 0..rows {
		for col in 0..cols {
			mut v := 0.0
			for i in 0..n {
				v += mo.mat[row*mo.cols + i] * mt.mat[i*mt.cols + col]
			}
			mx << v
		}
	}

	return generate_matrix(rows, cols, mx)

}

// given a function that takes a num and returns a num, apply it to all values in the matrix
pub fn (mut m Matrix) apply(op fn (f64) f64) {
	for i in 0..(m.rows * m.cols) {
		m.mat[i] = op(m.mat[i])
	}
}

// given matrix and a function that takes a num and returns a num, return a copy of the mtrix with function applied to all its values
pub fn apply(m Matrix, op fn (f64) f64) Matrix {
	mut rm := m.copy()
	rm.apply(op)
	return rm
}

// get the value from a specified spot
pub fn (m Matrix) get_value(row int, col int) f64 {
	return m.mat[row * m.cols + col]
}

// set the value at a given spot
pub fn (mut m Matrix) set_value(row int, col int, value f64) {
	m.mat[row * m.cols + col] = value
}

// calculate determinant from the matrix
pub fn (m Matrix) determinant() !f64 {
	if m.rows != m.cols {
		return error("Matrix was not square.")
	}

	n := m.rows

	mut am := m.copy()

	// TODO revisit the algorithm and properly explain this loop
	// this loop manipulates the rows of the matrix into upper triangular form
	for fd in 0..n {
		for i in (fd+1)..n {
			if am.mat[fd * am.cols + fd] == 0 {
				am.mat[fd * am.cols + fd] = 1.0e-18
			}
			mut cr_scaler := am.mat[i * am.cols +fd] / am.mat[fd * am.cols + fd]
			for j in 0..n {
				am.mat[i * am.cols + j] = am.mat[i * am.cols + j] - cr_scaler * am.mat[fd * am.cols + j]
			}
		}
	}

	mut product := 1.0

	// the product of the main diagnol is the determinant for upper triangular matrices
	for i in 0..n {
		product = product * am.mat[i * am.cols + i]
	} 

	return product
}

// given a matrix return its inverse
pub fn invert_matrix(m Matrix) !Matrix {
	if m.rows != m.cols {
		return error("Matrix is not square")
	}
	if m.determinant()! == 0.0 {
		return error("Matrix is singular")
	}

	mut n := m.rows
	mut am := m.copy()
	mut id := identity(n)
	mut im := id.copy()

	mut indices := []int
	for i in 0..n {
		indices << i
	}

	// TODO revisit algorithm and properly explain how this loop works
	for fd in 0..n {
		mut fd_scaler := 1.0 / am.mat[fd * am.rows + fd]
		for j in 0..n {
			am.mat[fd * am.cols + j] *= fd_scaler
			im.mat[fd * im.cols + j] *= fd_scaler
		}

		for i in 0..indices.len {
			if i != fd {
				mut cr_scaler := am.mat[i * am.cols + fd]

				for j in 0..n {
					am.mat[i * am.cols + j] = am.mat[i * am.cols + j] - cr_scaler * am.mat[fd * am.cols + j]
					im.mat[i * im.cols + j] = im.mat[i * im.cols + j] - cr_scaler * im.mat[fd * im.cols + j]
				}
			}
		}
	}

	return im

}

// set a matrix to its inverse
pub fn (mut m Matrix) invert_matrix() ! {
	m = invert_matrix(m)!
}

// matrix method add all values of input matrix to the calling matrix 
pub fn (mut m Matrix) add(mo Matrix) ! {
	if mo.rows != m.rows || mo.cols != m.cols {
		return error("Matrices have different Dimensions")
	}

	for i in 0..(m.rows * m.cols) {
		m.mat[i] += mo.mat[i]
	}
}

// given 2 matrices return their sum
pub fn add(mo Matrix, mt Matrix) !Matrix {
	mut cmo := mo.copy()
	cmo.add(mt)!
	return cmo
}

// matrix method: sub all values of input matrix from the calling matrix
pub fn (mut m Matrix) sub(mo Matrix) ! {
	if mo.rows != m.rows || mo.cols != m.cols {
		return error("Matrices have different Dimensions")
	}

	for i in 0..(m.rows * m.cols) {
			m.mat[i] -= mo.mat[i]
	}
}

// given two matrices return the difference between mo and mt
pub fn sub(mo Matrix, mt Matrix) !Matrix {
	mut cmo := mo.copy()
	cmo.sub(mt)!
	return cmo
}

// matrix method: scale every value by an input value
pub fn (mut m Matrix) scalar_mul(c int) {
	for i in 0..(m.rows * m.cols) {
			m.mat[i] *= c
	}
}

// given a matrix and num, return matrix scaled by the num
pub fn scalar_mul (m Matrix, c int) Matrix {
	mut cm := m.copy()
	cm.scalar_mul(c)
	return cm
}

// matrix method: transpose the given matrix
pub fn (mut m Matrix) transpose() {
	mut rows := m.cols
	mut cols := m.rows

	mut mx := []f64

	for  i in 0..m.cols {
		for j in 0..m.rows {
			mx << m.mat[j* m.cols + i]
		}
	}

	m = generate_matrix(rows, cols, mx)
}

// return the transpose of the input matrix
pub fn transpose(m Matrix) Matrix {
	mut cm := m.copy()
	cm.transpose()
	return cm
}

// matrix method: return the trace of the matrix (trace : sum of diagnol)
pub fn (m Matrix) trace() !f64 {
	if m.rows != m.cols {
		return error("Matrix was not square.")
	}
	
	mut tr := 0.0

	for i in 0..m.rows {
		tr += m.mat[i * m.cols + i]
	}

	return tr
}

// input a matrix and get its trace
pub fn trace(m Matrix) !f64 {
	return m.trace()
}

// given a list of matrices perform repeated multiplication
pub fn multiply_matrices(m_list []Matrix) !Matrix {
	mut m := m_list[0].copy()

	for i in 1..m_list.len {
		m = mul(m,m_list[i])!
	}

	return m
}