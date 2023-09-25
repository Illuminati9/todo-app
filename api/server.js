const express = require('express')
const mongoose = require('mongoose')
const cors = require('cors')
const dotenv = require('dotenv')
const app = express()
const bodyParser = require('body-parser')
const axios = require('axios');

dotenv.config();

app.use(bodyParser.json({limit: '30mb',extended:true}));
app.use(bodyParser.urlencoded({limit:'30mb',extended:true}));
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
    console.log(req.params.id);
    console.log(req.body.title, req.body.description);
    const todo = new Todo({
        title: req.body.title,
        description: req.body.description,
    })
    await todo.save();
    res.json(todo);
})

app.put('/todo/update/:id', async (req, res) => {
    console.log(req.params.id);
    console.log(req.body.title, req.body.description);
    await Todo.findByIdAndUpdate(req.params.id, 
        { title: req.body.title, description: req.body.description }, )
    // todo.title = req.body.title;
    // todo.description = req.body.description;
    // await todo.save();
    const todo = await Todo.findById(req.params.id);
    res.json(todo);
})

app.delete('/todo/delete/:id', async (req, res) => {
    console.log(req.params.id);
    const todo = await Todo.findByIdAndDelete(req.params.id);

    res.json(todo);
})

app.get('/todo/complete/:id', async (req, res) => {
    console.log(req.params.id);
    const todo = await Todo.findById(req.params.id);
    todo.complete = !todo.complete;
    todo.save();
    res.json(todo);
})

app.get('/translate/allLang',async(req,res)=>{

    const options = {
    method: 'GET',
    url: 'https://google-translate1.p.rapidapi.com/language/translate/v2/languages',
    headers: {
        'Accept-Encoding': 'application/gzip',
        'X-RapidAPI-Key': process.env.RAPID_KEY_SECRET,
        'X-RapidAPI-Host': 'google-translate1.p.rapidapi.com'
    }
    };

    try {
        const response = await axios.request(options);
        console.log(response.data);
        res.json({message:response.data,success:true});
    } catch (error) {
        console.error(error);
        res.json({message:"Something went wrong",success:false})
    }
})

app.post('/translate/detectLang',async(req,res)=>{
    const encodedParams = new URLSearchParams();
    encodedParams.set('q', req.body.text);

    const options = {
    method: 'POST',
    url: 'https://google-translate1.p.rapidapi.com/language/translate/v2/detect',
    headers: {
        'content-type': 'application/x-www-form-urlencoded',
        'Accept-Encoding': 'application/gzip',
        'X-RapidAPI-Key': process.env.RAPID_KEY_SECRET,
        'X-RapidAPI-Host': 'google-translate1.p.rapidapi.com'
    },
    data: encodedParams,
    };

    try {
        const response = await axios.request(options);
        console.log(response.data);
        res.json({message:response.data,success:true});
    } catch (error) {
        console.error(error);
        res.json({message:"Something went wrong",success:false})
    }
})

app.post('/translate/translateLang',async(req,res)=>{
    const text = req.body.text;

    const encodedParams = new URLSearchParams();
    encodedParams.set('q', req.body.text);
    encodedParams.set('target', req.body.targetLang);
    encodedParams.set('source', req.body.sourceLang);

    const options = {
    method: 'POST',
    url: 'https://google-translate1.p.rapidapi.com/language/translate/v2',
    headers: {
        'content-type': 'application/x-www-form-urlencoded',
        'Accept-Encoding': 'application/gzip',
        'X-RapidAPI-Key': process.env.RAPID_KEY_SECRET,
        'X-RapidAPI-Host': 'google-translate1.p.rapidapi.com'
    },
    data: encodedParams,
    };

    try {
        const response = await axios.request(options);
        console.log(response.data);
        res.json({message:response.data,success:true})
    } catch (error) {
        console.error(error);
        res.json({message:"Something went wrong",success:false})
    }
})

app.listen(5000, () => {
    console.log('server is listening on port 5000...')
})