const express = require('express');
const multer = require('multer');
const app = express();
const fs = require('fs');
const PORT = process.env.PORT || 3000;
const jwt = require('jsonwebtoken');
const path = require('path');
const cors = require('cors');
const { default: mongoose } = require('mongoose');
const Product = require('./modle/products')


app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors())




//test api
app.get('/', (req, res) => {
    res.send('hello world')
})

//storage engine 
const storage = multer.diskStorage({
    destination: './upload/images',// upload directory
    filename: (req, file, cb) => {
        return cb(null, `${file.fieldname}_${Date.now()}_${path.extname(file.originalname)}`)
    }
})

// Update product
app.put('/updateproduct/:id', async (req, res) => {
    try {
      const updatedProduct = await Product.findOneAndUpdate(
        { id: req.params.id },
        req.body,
        { new: true, runValidators: true }
      );
      if (updatedProduct) {
        res.json({ message: 'Product updated successfully', updatedProduct });
      } else {
        res.status(404).json({ message: 'Product not found' });
      }
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  });
  


//upload endpoint
const upload = multer({ storage: storage })
app.use('/images', express.static('upload/images'))

app.post("/upload", upload.single('product'), (req, res) => {
    try {
        res.json({
            success: 1,
            image_url: `http:localhost:${PORT}/images/${req.file.filename}`
        })
    } catch (error) {
        res.status(500).json({ message: error.message })
    }
})
app.get('/allimages', (req, res) => {
    const directoryPath = path.join(__dirname, 'upload/images');
    fs.readdir(directoryPath, (err, files) => {
        if (err) {
            return res.status(500).json({ message: 'Unable to scan files', error: err });
        }
        const fileUrls = files.map((file) => `${req.protocol}://${req.get('host')}/images/${file}`);
        res.json(fileUrls);
    });
});

//add products

app.post("/addproduct", async (req, res) => {
    let products = await Product.find({});
    let id;
    if (products.length > 0) {
        let last_product_array = products[products.length - 1];
        id = last_product_array.id + 1;
    } else { id = 1 }
    try {
        const product = new Product({
            id: id,
            name: req.body.name,
            old_price: req.body.old_price,
            new_price: req.body.new_price,
            description: req.body.description,
            image: req.body.image,
            category: req.body.category
        })
        console.log(product)
        await product.save()
        res.json({ message: "product added successfully" })


    } catch (error) {
        res.status(500).json({ message: error.message })
    }
})


//deleting products
app.delete('/removeproduct',async(req,res)=>{
try {
    await Product.findOneAndDelete({name: req.body.name})
    res.send(req.name + 'removed succesfully')
} catch (error) {
    res.status(500).json({ message: error.message })
}
})

//get all products

app.get('/allproduct',async(req,res)=>{
    try {
       const allproducts= await Product.find()
        res.json(allproducts)
    } catch (error) {
        res.status(500).json({ message: error.message })
    }
})





mongoose.connect('mongodb+srv://admin:admin123@cluster0.iuwwo.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0').then(() => {
    console.log('Connected to MongoDB');
    app.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}`)
    }
    )
})




