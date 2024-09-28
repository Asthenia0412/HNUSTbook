const sqlite3 = require('sqlite3').verbose();
const path = require('path'); // 引入path模块用于处理文件路径

// 定义数据库文件路径，这里假设数据库文件存放在当前目录的'database'文件夹中，文件名为'article.db'
const dbPath = path.join(__dirname, 'database', 'article.db');

// 使用文件路径创建数据库实例
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error(err.message);
  }
  console.log('Connected to the SQLite database.');
});

db.serialize(() => {
  // 创建表
  db.run(`CREATE TABLE IF NOT EXISTS articles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT NOT NULL
  )`, (err) => {
    if (err) {
      console.error(err.message);
    } else {
      console.log('Table created or already exists.');
    }
  });
});

// 导出数据库实例，以便其他模块可以使用
module.exports = db;
