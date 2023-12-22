const mongoose = require('mongoose')
require('dotenv').config()

module.exports = {
	async connectBD() {
		mongoose.connect(process.env.MONGO_DB, {})
	}
}
