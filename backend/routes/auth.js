const usuario_model = require('../model/user_model')
import jwt from 'jsonwebtoken'
import bcrypt from 'bcrypt'

module.exports = (app) => {
	app.post('/api/login', (req, res) => {
		usuario_model
			.findOne({ email: req.body.email })
			.then((datos) => {
				if (
					datos &&
					bcrypt.compareSync(req.body.password, datos.password) == true
				) {
					// Verify email and password
					const jwtoken = jwt.sign(
						{
							// token with data
							usuario: {
								_id: datos._id,
								username: datos.username,
								email: datos.email
							}
						},
						process.env.SECRET_KEY,
						{ expiresIn: process.env.TOKEN_EXPIRE_TIME }
					)
					return res.status(200).send({
						accessToken: jwtoken
					})
				} else {
					return res
						.status(400)
						.send({ error: 'El usuario o constraseña incorrecta' })
				}
			})
			.catch((error) => {
				return res.status(400).send({
					error: error
				})
				//return { statusCode: 500, error: "Error interno del servidor " + error }
			})
	})
}
