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

pub fn fill_matrix(rows ...[]f64) Matrix {
	mut r := 0
	mut c := 0
	mut wc := 0
	mut mx := [][]f64

	for row in rows {
		mx << row
		r++
		c = row.len
		if wc == 0 {
			wc = c
		}

		// if wc != c {
		// 	return error("Column len varies")
		// }
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

pub fn mul(mo Matrix, mt Matrix) Matrix {
	if mo.cols != mt.rows {
		//error
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

pub fn (mut m Matrix) determinant() f64 {
	// if m.rows != m.cols {
	// 	// errror
	// }

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


