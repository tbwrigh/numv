module numv

pub struct Matrix {
pub mut:
	rows int
	cols int
	mat [][]f64
}

pub fn generate_matrix(rows int, cols int, mx [][]f64) Matrix {
	return Matrix{
		rows : rows
		cols: cols
		mat: mx
	}
}

pub fn (m Matrix) copy() Matrix {
	mut r := m.rows
	mut c := m.cols
	mut mx := [][]f64
	for i in 0..r {
		mut row := []f64
		for j in 0..c {
			row << m.mat[i][j]
		}
		mx << row
	}
	return generate_matrix(r,c,mx)
}

pub fn fill_matrix(rows ...[]f64) !Matrix {
	mut r := 0
	mut c := 0
	mut wc := 0
	mut mx := [][]f64

	for row in rows {
		mx << row
		r++
		c = row.len
		if row.len != 0 && wc == 0 {
			wc = c
		}

		if wc != c {
			return error("Column len varies")
		}
	}

	return generate_matrix(r, c, mx)

}

pub fn zeroes(rows int, cols int) Matrix {
	mut mx := [][]f64
	for row in 0..rows {
		mut r := []f64
		for col in 0..cols {
			r << 0
		}
		mx << r
	}

	return generate_matrix(rows, cols, mx)
}

pub fn identity(dim int) Matrix {
	mut rows := dim
	mut cols := dim
	mut mx := [][]f64
	for row in 0..rows {
		mut r := []f64
		for col in 0..cols {
			if row == col {
				r << 1
			}else {
				r << 0
			}
		}
		mx << r
	}

	return generate_matrix(rows, cols, mx)
}

pub fn (m Matrix) print() {
	for row in m.mat {
		for entry in row {
			print (entry)
			print (" ")
		}
		println("")
	}
}

pub fn mul(mo Matrix, mt Matrix) !Matrix {
	if mo.cols != mt.rows {
		return error("Matrices cannot be multiplied. Incorrent Dimensions.")
	}

	mut rows := mo.rows
	mut cols := mt.cols

	mut n := mo.cols

	mut mx := [][]f64

	for row in 0..rows {
		mut r := []f64
		for col in 0..cols {
			mut v := 0.0
			for i in 0..n {
				v += mo.mat[row][i] * mt.mat[i][col]
			}
			r << v
		}
		mx << r
	}

	return generate_matrix(rows, cols, mx)

}

pub fn (mut m Matrix) apply(op fn (f64) f64) {
	for row in 0..m.rows {
		for col in 0..m.cols {
			m.mat[row][col] = op(m.mat[row][col])
		}
	}
}

pub fn apply(m Matrix, op fn (f64) f64) Matrix {
	mut rm := m.copy()
	rm.apply(op)
	return rm
}


pub fn (m Matrix) get_value(row int, col int) f64 {
	return m.mat[row][col]
}

pub fn (mut m Matrix) set_value(row int, col int, value f64) {
	m.mat[row][col] = value
}

pub fn (m Matrix) determinant() !f64 {
	if m.rows != m.cols {
		return error("Matrix was not square.")
	}

	n := m.rows

	mut am := m.copy()

	for fd in 0..n {
		for i in (fd+1)..n {
			if am.mat[fd][fd] == 0 {
				am.mat[fd][fd] = 1.0e-18
			}
			mut cr_scaler := am.mat[i][fd] / am.mat[fd][fd]
			for j in 0..n {
				am.mat[i][j] = am.mat[i][j] - cr_scaler * am.mat[fd][j]
			}
		}
	}

	mut product := 1.0

	for i in 0..n {
		product = product * am.mat[i][i]
	} 

	return product
}

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

	for fd in 0..n {
		mut fd_scaler := 1.0 / am.mat[fd][fd]
		for j in 0..n {
			am.mat[fd][j] *= fd_scaler
			im.mat[fd][j] *= fd_scaler
		}

		for i in 0..indices.len {
			if i != fd {
				mut cr_scaler := am.mat[i][fd]

				for j in 0..n {
					am.mat[i][j] = am.mat[i][j] - cr_scaler * am.mat[fd][j]
					im.mat[i][j] = im.mat[i][j] - cr_scaler * im.mat[fd][j]
				}
			}
		}
	}

	return im

}

pub fn (mut m Matrix) add(mo Matrix) ! {
	if mo.rows != m.rows || mo.cols != m.cols {
		return error("Matrices have different Dimensions")
	}

	for i in 0..m.rows {
		for j in 0..m.cols {
			m.mat[i][j] += mo.mat[i][j]
		}
	}
}

pub fn add(mo Matrix, mt Matrix) !Matrix {
	mut cmo := mo.copy()
	cmo.add(mt)!
	return cmo
}
