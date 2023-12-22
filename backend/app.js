import express from 'express' //import path from 'path'
import config from './database/config'
import cors from 'cors'
import morgan from 'morgan'
const app = express()

app.use(morgan('tiny'))
app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

require('./routes')(app)

app.set('port', process.env.PORT || 5001)
// Create a MongoClient with a MongoClientOptions object to set the Stable API version

config.connectBD().then(() => console.log('DB Online'))
app.listen(app.get('port'), () =>
	console.log(`Listening on port ${app.get('port')}...`)
)
