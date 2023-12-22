const reporteController = require('../controller/reporte')
const verifyToken = require('../middleware/auth')

module.exports = (app) => {
	//* Create new Report
	app.post('/api/report', verifyToken, async (req, res) => {
		let result
		try {
			result = await reporteController.createReporte(req)
		} catch (error) {
			result = { statusCode: 400, error: error }
		}
		return !result
			? res.status(500).send({ error: 'Error interno del servidor' })
			: result.statusCode !== 200
			  ? res.status(result.statusCode).send(result.error)
			  : res.status(200).send(result.data)
	})
	//* Get all reports
	app.get('/api/reports', verifyToken, async (req, res) => {
		let result
		try {
			result = await reporteController.getReportes()
		} catch (error) {
			result = { statusCode: 400, error: error }
		}
		return !result
			? res.status(500).send({ error: 'Error interno del servidor' })
			: result.statusCode !== 200
			  ? res.status(result.statusCode).send(result.error)
			  : res.status(200).send(result.data)
	})

	//* Get report by id
	app.get('/api/report/:id', verifyToken, async (req, res) => {
		let result
		try {
			result = await reporteController.getReportById(req.params.id)
		} catch (error) {
			result = { statusCode: 400, error: error }
		}
		return !result
			? res.status(500).send({ error: 'Error interno del servidor' })
			: result.statusCode !== 200
			  ? res.status(result.statusCode).send(result.error)
			  : res.status(200).send(result.data)
	})

	//* Add comment to report
	app.post('/api/report/comment', verifyToken, async (req, res) => {
		let result
		try {
			result = await reporteController.addComment(req)
		} catch (error) {
			result = { statusCode: 400, error: error }
		}
		return !result
			? res.status(500).send({ error: 'Error interno del servidor' })
			: result.statusCode !== 200
			  ? res.status(result.statusCode).send(result.error)
			  : res.status(200).send(result.data)
	})

	//* Vote add report

	app.put('/api/report/vote/still', verifyToken, async (req, res) => {
		let result
		try {
			result = await reporteController.votestill(req.body)
		} catch (error) {
			result = { statusCode: 400, error: error }
		}
		return !result
			? res.status(500).send({ error: 'Error interno del servidor' })
			: result.statusCode !== 200
			  ? res.status(result.statusCode).send(result.error)
			  : res.status(200).send(result.data)
	})

	app.put('/api/report/vote/nostill', verifyToken, async (req, res) => {
		let result
		try {
			result = await reporteController.votenostill(req.body)
		} catch (error) {
			result = { statusCode: 400, error: error }
		}
		return !result
			? res.status(500).send({ error: 'Error interno del servidor' })
			: result.statusCode !== 200
			  ? res.status(result.statusCode).send(result.error)
			  : res.status(200).send(result.data)
	})
}
