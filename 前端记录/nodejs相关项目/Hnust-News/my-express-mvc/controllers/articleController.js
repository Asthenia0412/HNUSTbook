const Article = require('../models/article');

const articleController = {
  getAllArticles: (req, res) => {
    Article.getAllArticles((err, articles) => {
      if (err) {
        res.status(500).send(err);
      } else {
        res.status(200).json(articles);
      }
    });
  },
  addArticle: (req, res) => {
    Article.addArticle(req.body, (err, id) => {
      if (err) {
        res.status(500).send(err);
      } else {
        res.status(201).json({ id: id });
      }
    });
  }
};

module.exports = articleController;
