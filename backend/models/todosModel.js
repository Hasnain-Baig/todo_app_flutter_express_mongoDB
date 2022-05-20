const mongoose=require('mongoose');

const ToDoSchema=new mongoose.Schema({
    item:{
        type:String,
        required:true
    },
});

var toDoModel=mongoose.model("todos",ToDoSchema);
module.exports=toDoModel;