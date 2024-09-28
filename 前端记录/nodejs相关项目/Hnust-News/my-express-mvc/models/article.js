const db = require('../db/database');

const Article = {
  getAllArticles: (callback) => {
    const sql = 'SELECT * FROM articles';
    db.all(sql, [], (err, rows) => {
      if (err) {
        callback(err, null);
      } else {
        callback(null, rows);
      }
    });
  },
  addArticle: (data, callback) => {
    const sql = 'INSERT INTO articles (title, content) VALUES (?, ?)';
    db.run(sql, [data.title, data.content], (err) => {
      if (err) {
        callback(err, null);
      } else {
        callback(null, this.lastID);
      }
    });
  }
};

module.exports = Article;
