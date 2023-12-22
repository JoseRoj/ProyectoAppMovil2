const mongoose = require('mongoose')
const schema = mongoose.Schema

const comentarioSchema = new mongoose.Schema({
	autor: {
		type: schema.Types.ObjectId,
		ref: 'user'
	},
	date: {
		type: Date,
		default: Date.now()
	},
	description: {
		type: String,
		required: true
	}
})
const reporteSchema = new mongoose.Schema({
	sector: {
		type: String,
		required: true
	},
	autor: {
		type: schema.Types.ObjectId,
		ref: 'user'
	},
	date: {
		type: Date,
		default: Date.now()
	},
	description: {
		type: String,
		required: true
	},
	images: [
		{
			type: String
		}
	],
	comment: [
		{
			type: comentarioSchema
		}
	],
	still: {
		type: Number,
		default: 0
	},
	notStill: {
		type: Number,
		default: 0
	}
})

module.exports = mongoose.model('reporte', reporteSchema)
