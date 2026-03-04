const mongoose=require("mongoose");
const clientschema=new mongoose.Schema({
    name:String,
    email:String,
    company:String,
});
module.exports=mongoose.model("Client",clientschema);