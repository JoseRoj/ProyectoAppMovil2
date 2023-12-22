const mongoose = require('mongoose')

const usuariosSchema = new mongoose.Schema({
	email: {
		type: String,
		required: true,
		unique: true
	},
	nombre: {
		type: String,
		required: true
	},
	apellido: {
		type: String,
		required: true
	},
	username: {
		type: String,
		required: true
	},
	password: {
		type: String,
		required: true
	},
	image: {
		type: String,
		required: false
	}
})

module.exports = mongoose.model('user', usuariosSchema)
