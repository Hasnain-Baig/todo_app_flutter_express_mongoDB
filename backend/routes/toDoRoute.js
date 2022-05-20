const express = require('express')
const router = express.Router()
const mongoose=require('mongoose')
const todoModel = require("../models/todosModel")


// getRoot
router.get('/', (req, res) => {
    // res.send('All Todos')
    todoModel.find({}, (error, result) => {
        if (error) {
            res.json(error)
        }
        else {
            res.json(result)
        }
    })
})

router.get('/:id', (req, res) => {
console.log(req.params.id);
    // res.send('Server get 1 Apis Route!')
    const id=req.params.id;
    todoModel.findById(id,(error,result)=>{
        if (error){
            res.json(error)
        }
        else{
            res.json(result)
        }    
    })

})

router.post('/', async (req, res) =>{
console.log(req.body);
const todo = req.body;
todo._id=mongoose.Types.ObjectId();
const newTodo = new todoModel(todo);
await newTodo.save();
res.json(todo)
})

router.put('/:id', (req, res) => {
    console.log(req.params);
    console.log(req.body);
    const id=req.params.id;
    const item=req.body.item;

    todoModel.findByIdAndUpdate(id,{item:item},(error,result)=>{
        if (error){
            res.json(error)
        }
        else{
            res.json({_id:id,item:item})
        }    
    })

})

router.delete('/:id', (req, res) => {
    const id=req.params.id;

    todoModel.findByIdAndDelete(id,(error,result)=>{
        if (error){
            res.json(error)
        }
        else{
            res.json(result)
        }    
    })
})

module.exports = router;