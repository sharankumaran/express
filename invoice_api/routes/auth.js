const express=require("express");
const bcrypt=require("bcryptjs");
const jwt=require("jsonwebtoken");
const User=require("../models/user");

const router=express.Router();

//registerrrrrrrrr
router.post("/register",async(req,res)=>{
    const{name,email,password}=req.body;
    const hashed=await bcrypt.hash(password,10);
    await User.create({
        name,
        email,
        password:hashed,
    });
    res.status(201).json({message:"Registered succesfully"});
});

//loginnnnnnnnnnnnnnnnnnn
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email }); // ✅ FIXED

    if (!user) {
      return res.status(401).json({ message: "User not found" });
    }

    const match = await bcrypt.compare(password, user.password);

    if (!match) {
      return res.status(401).json({ message: "Password incorrect" });
    }
    console.log("JWT SECRET:", process.env.JWT_SECRET);
    const token = jwt.sign(
      { id: user._id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: "1d" }
    );

    res.json({ token });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});
module.exports=router;