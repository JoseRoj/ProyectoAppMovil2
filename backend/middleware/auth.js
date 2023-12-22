import jwt from 'jsonwebtoken'

let verifyToken = (req, res, next) => {
	let token = req.get('Authorization')
	jwt.verify(token, process.env.SECRET_KEY, (err, decoded) => {
		if (err) {
			return res.status(401).send({ error: err })
		}
		req.user = decoded.usuario
		next()
	})
}
module.exports = verifyToken
