const reporte_model = require('../model/reporte_model')

module.exports = {
	async createReporte(req) {
		try {
			let newReporte = new reporte_model({
				sector: req.body.sector,
				autor: req.user,
				description: req.body.description,
				images: req.body.images
			})
			await newReporte.save()
			return !newReporte
				? { statusCode: 400, error: 'No se pudo crear el reporte' }
				: {
						statusCode: 200,
						data: {
							nombre: newReporte.nombre,
							email: newReporte.email
						}
				  }
		} catch (error) {
			console.log(error)
			return { statusCode: 500, error: error }
		}
	},
	async getReportes() {
		try {
			let reportes = await reporte_model
				.find()
				.select()
				.populate('autor', { username: 1 })
				.populate('comment.autor', { username: 1 })
			//.populate('comment.autor', { password: 0 })

			return !reportes
				? { statusCode: 400, error: 'No se pudo listar los reportes' }
				: { statusCode: 200, data: reportes }
		} catch (error) {
			return { statusCode: 500, error: error }
		}
	},
	async getReportById(id) {
		try {
			let reporte = await reporte_model
				.findById(id)
				.select()
				.populate('autor', { username: 1 })
				.populate('comment.autor', { username: 1 })

			return !reporte
				? { statusCode: 400, error: 'No se pudo listar el reporte' }
				: { statusCode: 200, data: reporte }
		} catch (error) {
			return { statusCode: 500, error: error }
		}
	},
	async addComment(req) {
		try {
			let report = await reporte_model.findById(req.body.id)
			report.comment.push({
				autor: req.user,
				description: req.body.description
			})
			await report.save()
			console.log(report)
			return !report
				? { statusCode: 400, error: 'No se pudo comentat el reporte' }
				: { statusCode: 200, data: report }
		} catch (error) {
			return { statusCode: 500, error: error }
		}
	},
	async votestill(body) {
		try {
			let report = await reporte_model.findById(body.id)
			report.still += 1
			await report.updateOne({ still: report.still })

			await report.save()
			return !report
				? { statusCode: 400, error: 'Error al agregar voto' }
				: { statusCode: 200, data: report }
		} catch (error) {
			return { statusCode: 500, error: error }
		}
	},
	async votenostill(body) {
		try {
			let report = await reporte_model.findById(body.id)
			report.notStill += 1
			await report.updateOne({ notStill: report.notStill })
			//await report.save()
			return !report
				? { statusCode: 400, error: 'Error al agregar voto' }
				: { statusCode: 200, data: report }
		} catch (error) {
			return { statusCode: 500, error: error }
		}
	}
}
