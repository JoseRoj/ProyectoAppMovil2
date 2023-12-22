const user_model = require('../model/user_model')
import bcrypt from 'bcrypt'

module.exports = {
	async createUsers(body) {
		try {
			let newUser = new user_model({
				email: body.email,
				username: body.username,
				nombre: body.nombre,
				apellido: body.apellido,
				password: bcrypt.hashSync(body.password, 10)
			})
			console.log(newUser.nombre + newUser.email)
			await newUser.save()
			return !newUser
				? { statusCode: 400, error: 'No se pudo crear el usuario' }
				: {
						statusCode: 200
				  }
		} catch (error) {
			console.log(error)
			return { statusCode: 500, error: error }
		}
	},
	async getUsers() {
		try {
			let users = await user_model
				.find()
				.select({ nombre: 1, apellido: 1, email: 1, username: 1 })

			return !users
				? { statusCode: 400, error: 'No se pudo listar los usuarios' }
				: { statusCode: 200, data: users }
		} catch (error) {
			return { statusCode: 500, error: error }
		}
	}
}
