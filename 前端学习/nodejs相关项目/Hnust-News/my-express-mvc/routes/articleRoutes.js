const express = require('express');
const router = express.Router();
const articleController = require('../controllers/articleController');
const multer = require('multer');
const upload = multer({ dest: 'uploads/' });

router.get('/', articleController.getAllArticles);
router.post('/add', upload.none(), articleController.addArticle);

module.exports = router;
