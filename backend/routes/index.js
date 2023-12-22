const fs = require('fs')
const path = require('path')

module.exports = (app) => {
	app.get('/api', (_req, res) => {
		res.status(200).send({
			data: 'Welcome Node Sequlize API v1'
		})
	})

	fs.readdirSync(__dirname)
		.filter((file) => file !== 'index.js' && file.endsWith('.js'))
		.forEach((file) => {
			const route = require(path.join(__dirname, file))
			route(app)
		})
}
