module numv

pub struct Matrix {
pub mut:
	rows int
	cols int
	mat []f64
}

pub fn generate_matrix(rows int, cols int, mx []f64) Matrix {
	return Matrix{
		rows : rows
		cols: cols
		mat: mx
	}
}

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
	mut mx := []f64
	for row in 0..(rows*cols) {
		mx << 0
	}
	return generate_matrix(rows, cols, mx)
}

pub fn identity(dim int) Matrix {
	mut rows := dim
	mut cols := dim
	mut mx := []f64
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

pub fn (m Matrix) print() {
	for i in 0..m.rows {
		for j in 0..m.cols {
			print(m.mat[i * m.cols + j])
			print(" ")
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

	mut mx := []f64

	for row in 0..rows {
		for col in 0..cols {
			mut v := 0.0
			for i in 0..n {
				v += mo.mat[row*rows + i] * mt.mat[i*rows + col]
			}
			mx << v
		}
	}

	return generate_matrix(rows, cols, mx)

}

pub fn (mut m Matrix) apply(op fn (f64) f64) {
	for i in 0..(m.rows * m.cols) {
		m.mat[i] = op(m.mat[i])
	}
}

pub fn apply(m Matrix, op fn (f64) f64) Matrix {
	mut rm := m.copy()
	rm.apply(op)
	return rm
}


pub fn (m Matrix) get_value(row int, col int) f64 {
	return m.mat[row * m.rows + col]
}

pub fn (mut m Matrix) set_value(row int, col int, value f64) {
	m.mat[row * m.rows + col] = value
}

pub fn (m Matrix) determinant() !f64 {
	if m.rows != m.cols {
		return error("Matrix was not square.")
	}

	n := m.rows

	mut am := m.copy()

	for fd in 0..n {
		for i in (fd+1)..n {
			if am.mat[fd * am.rows + fd] == 0 {
				am.mat[fd * am.rows + fd] = 1.0e-18
			}
			mut cr_scaler := am.mat[i * am.rows +fd] / am.mat[fd * am.rows + fd]
			for j in 0..n {
				am.mat[i * am.rows + j] = am.mat[i * am.rows + j] - cr_scaler * am.mat[fd * am.rows + j]
			}
		}
	}

	mut product := 1.0

	for i in 0..n {
		product = product * am.mat[i * am.rows + i]
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
		mut fd_scaler := 1.0 / am.mat[fd * am.rows + fd]
		for j in 0..n {
			am.mat[fd * am.rows + j] *= fd_scaler
			im.mat[fd * im.rows + j] *= fd_scaler
		}

		for i in 0..indices.len {
			if i != fd {
				mut cr_scaler := am.mat[i * am.rows + fd]

				for j in 0..n {
					am.mat[i * am.rows + j] = am.mat[i * am.rows + j] - cr_scaler * am.mat[fd * am.rows + j]
					im.mat[i * im.rows + j] = im.mat[i * im.rows + j] - cr_scaler * im.mat[fd * im.rows + j]
				}
			}
		}
	}

	return im

}

pub fn (mut m Matrix) invert_matrix() ! {
	m = invert_matrix(m)!
}

pub fn (mut m Matrix) add(mo Matrix) ! {
	if mo.rows != m.rows || mo.cols != m.cols {
		return error("Matrices have different Dimensions")
	}

	for i in 0..(m.rows * m.cols) {
		m.mat[i] += mo.mat[i]
	}
}

pub fn add(mo Matrix, mt Matrix) !Matrix {
	mut cmo := mo.copy()
	cmo.add(mt)!
	return cmo
}

pub fn (mut m Matrix) sub(mo Matrix) ! {
	if mo.rows != m.rows || mo.cols != m.cols {
		return error("Matrices have different Dimensions")
	}

	for i in 0..(m.rows * m.cols) {
			m.mat[i] -= mo.mat[i]
	}
}

pub fn sub(mo Matrix, mt Matrix) !Matrix {
	mut cmo := mo.copy()
	cmo.sub(mt)!
	return cmo
}

pub fn (mut m Matrix) scalar_mul(c int) {
	for i in 0..(m.rows * m.cols) {
			m.mat[i] *= c
	}
}

pub fn scalar_mul (m Matrix, c int) Matrix {
	mut cm := m.copy()
	cm.scalar_mul(c)
	return cm
}

pub fn (mut m Matrix) transpose() {
	mut rows := m.cols
	mut cols := m.rows

	mut mx := []f64

	for  i in 0..m.cols {
		for j in 0..m.rows {
			mx << m.mat[j* m.rows + i]
		}
	}

	m = generate_matrix(rows, cols, mx)
}

pub fn transpose(m Matrix) Matrix {
	mut cm := m.copy()
	cm.transpose()
	return cm
}

pub fn (m Matrix) trace() !f64 {
	if m.rows != m.cols {
		return error("Matrix was not square.")
	}
	
	mut tr := 0.0

	for i in 0..m.rows {
		tr += m.mat[i * m.rows + i]
	}

	return tr
}

pub fn trace(m Matrix) !f64 {
	return m.trace()
}

pub fn multiply_matrices(m_list []Matrix) !Matrix {
	mut m := m_list[0].copy()

	for i in 1..m_list.len {
		m = mul(m,m_list[i])!
	}

	return m
}