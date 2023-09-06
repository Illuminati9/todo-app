const express = require('express')
const mongoose = require('mongoose')
const cors = require('cors')
const dotenv = require('dotenv')
const app = express()

dotenv.config();
app.use(express.json())
app.use(cors())

mongoose.connect(process.env.MONGO_URL, {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(() => {
    console.log('connected to DB')
}).catch((err) => {
    console.log(err)
})

const Todo = require('./models/Todo')

app.get('/',(req,res)=>{
    res.send("hello world");
})

app.get('/todos', async (req, res) => {
    const todos = await Todo.find();

    res.json(todos);
})

app.post('/todo/new', async (req, res) => {
    const todo = new Todo({
        title: req.body.title,
        description: req.body.description,
    })
    await todo.save();
    res.json(todo);
})

app.put('/todo/update/:id', async (req, res) => {
    print(req.params.id);
    await Todo.findByIdAndUpdate(req.params.id, 
        { title: req.body.title, description: req.body.description }, )
    // todo.title = req.body.title;
    // todo.description = req.body.description;
    // await todo.save();
    const todo = await Todo.findById(req.params.id);
    res.json(todo);
})

app.delete('/todo/delete/:id', async (req, res) => {
    print(req.params.id);
    const todo = await Todo.findByIdAndDelete(req.params.id);

    res.json(todo);
})

app.get('/todo/complete/:id', async (req, res) => {
    print(req.params.id);
    const todo = await Todo.findById(req.params.id);
    todo.complete = !todo.complete;
    todo.save()
    res.json(todo)
})

app.listen(5000, () => {
    console.log('server is listening on port 5000...')
})