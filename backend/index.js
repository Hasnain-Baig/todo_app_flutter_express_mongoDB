const express = require('express')
const app = express()
const cors=require('cors')
const mongoose=require('mongoose')
const mainRoute=require('./routes/mainRoute')
const toDoRoute=require('./routes/toDoRoute')


const port = process.env.PORT || 4000

// mongoose.connect("mongodb+srv://admin:czwnjrnoTE8aoDsx@first.u4stp.mongodb.net/test");
mongoose.connect("mongodb+srv://admin:czwnjrnoTE8aoDsx@first.u4stp.mongodb.net/todo-app-flutter?retryWrites=true&w=majority")
.then(()=>{console.log("MONOGO DB CONNECTED")})
.catch((err)=>{console.log("Connection Error:",err)})


app.use(express.json());//for using req.body
app.use(cors());//for react and express connection

app.use('/apis',mainRoute);
app.use('/apis/todos',toDoRoute);

app.listen(port, () => {
  console.log(`Example app listening on http://localhost:${port}/apis`)
})