const userController = require('../controller/user')
//const { stat } = require('fs')
const Joi = require('joi')
//const config = require('config')
//const jwt = require('jsonwebtoken')
const verifyToken = require('../middleware/auth')
const schema = Joi.object({
	nombre: Joi.string().min(3).max(30).required(),
	password: Joi.string().pattern(new RegExp('^[a-zA-Z0-9]{3,30}$')).required(),
	email: Joi.string().email({
		minDomainSegments: 2,
		tlds: { allow: ['com', 'net', 'cl'] }
	})
})

module.exports = (app) => {
	app.get('/api/users', verifyToken, async (req, res) => {
		let result
		try {
			result = await userController.getUsers()
		} catch (error) {
			result = { statusCode: 400, error: error }
		}
		return !result
			? res.status(500).send({ error: 'Error interno del servidor' })
			: result.statusCode !== 200
			  ? res.status(result.statusCode).send(result.error)
			  : res.status(200).send(result.data)
	})

	app.post('/api/user', async (req, res) => {
		console.log('result')

		let result
		let body = req.body

		// Validate the data
		const { error } = schema.validate({
			nombre: body.nombre,
			email: body.email,
			password: body.password
		})
		if (!error) {
			try {
				result = await userController.createUsers(body)
			} catch (error) {
				result = { statusCode: 400, error: error }
			}
		} else {
			result = { statusCode: 400, error: error }
		}
		return !result
			? res.status(500).send({ error: 'Error interno del servidor' })
			: result.statusCode !== 200
			  ? res.status(result.statusCode).send({ error: result.error })
			  : res.status(200).send(result.data)
	})
}
