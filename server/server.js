const { Socket } = require("dgram");
var express = require("express");
var app = express();
var server = require("http").createServer(app);
var io = require("socket.io")(server);
var bodyParser = require('body-parser');

//MySQL npm install socket.io mysql
var mysql = require('mysql');
var db = mysql.createConnection({
    connectionLimit: 100,
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'mobilfinal0',
    debug:   false
})

app.use(bodyParser.urlencoded({
  extended:true
}));


db.connect(function(err){
    if (err) console.log("db err :"+err);
    else console.log('Veri Tabanı Bağlantısı Başarılı');
})

// Create Route
app.get("/", function(req, res, next) {
  res.sendFile(__dirname + "/public/index.html");
});
app.use(express.static("public"));

app.post("/register", function(req, res) {
db.query("INSERT INTO `users` (`username`,`password`, `cinsiyet`, `statu`) VALUES ('"+req.body.username+"','"+req.body.password+"','"+req.body.cinsiyet+"', '"+req.body.giris_statusu+"')")
});

app.post("/login", function(req, res) {
  console.log('post');
  const username = req.body.username;
  const password = req.body.password;
  const giris_statusu = req.body.giris_statusu;
  if(giris_statusu == "HASTA") {
    db.query(" SELECT * FROM users WHERE username = '"+username+"' AND password = '"+password+"' ", function(err, result) {
      if(err) throw err;

      console.log('Query result: ', result.length);
      var count = result.length;
      console.log(result);
      
      if(count >= 1){
        //console.log(result);
        res.send(result);
      }
      else {
        res.send("Basarisiz")
      }
    });  
  } else {
    db.query(" SELECT * FROM doktorlar WHERE username = '"+username+"' AND password = '"+password+"' ", function(err, result) {
      if(err) throw err;

      console.log('Query result: ', result.length);
      var count = result.length;
      console.log(result);
      
      if(count >= 1){
        //console.log(result);
        res.send(result);
      }
      else {
        res.send("Basarisiz")
      }
    });
  }
});

app.get("/fetchAllUsers/:statu", function(req, res) {
console.log(req.params.statu);
statu = req.params.statu;
  if(statu == "HASTA") {
    db.query("SELECT * FROM doktorlar WHERE statu = 'DOKTOR' ", function(err, result){
      if(err) throw err;
        res.send(result);
        console.log(result)
    });
    
  } else {
    db.query("SELECT * FROM users", function(err, result) {
      if(err) throw err;
      res.send(result);
      console.log(result);
    });
  }
});

app.get("/fetchAnaBilimDallari", function(req, res) {
  db.query("SELECT * FROM anabilimdali", function(err, result) {
    if(err) throw err;
    console.log(result);
    res.send(result);
  });
});

app.get("/getSearchDoctors", function (req, res) {
  db.query("SELECT * FROM doktorlar", function(err, result) {
    if(err) throw err;
    //console.log("bura");
    //console.log(result);
    res.send(result);
  });
});

/* app.get("/getSearchDoctors2/:anaBilimId", function (req, res) {
  var i = req.params.anaBilimId;
  console.log(i);
  db.query("select anabilimdali from anabilimdali where id = (select anaBilimId from doktorlar where id = '"+i+"')", function(err, result) {
    if(err) throw err;
    console.log("test1213132132123123");
    console.log(result);
    res.send(result);
  });
  select anabilimadi from anabilimtable where anabilimID  = (select anabilimid from doktortable)
}); */

app.get("/getSearchUsers", function (req, res) {
  db.query("SELECT * FROM users", function(err, result) {
    if(err) throw err;
    //console.log("bura");
    //console.log(result);
    res.send(result);
  });
});


var onlineId;
var onlineId2;
// On Connection
io.on("connection", function(client) {

  console.log(client.id + "  Giriş Yaptı");
  
  client.on('onlineDoktor', function(data){
    console.log(data);
    onlineId = data;
  });

  client.emit('doktorOnline', onlineId);

  client.on('onlineHasta', function(data){
    console.log(data);
    onlineId2 = data;
  });

  client.emit('hastaOnline', onlineId2);

  client.on("messages", function(data) {
    console.log(data);
    client.emit("thread", data);
    client.broadcast.emit("thread", data);
    db.query("INSERT INTO `messages` (`user_id`,`user_to`,`message`, `statu`) VALUES ('"+data.user_id+"','"+data.user_to+"','"+data.message+"', '"+data.statu+"')")
  });

  client.on('sonMesaj', function(data) {
    var array0 = [];
    db.query("SELECT user_id")
  });

  client.on('fetchOldMessages', function(data) {
    console.log("test");
    var array = [];
    console.log(data);
    if(data.statu == "HASTA") {
      db.query("SELECT user_id, user_to, message, statu FROM `messages` WHERE (user_id='"+data.user_id+"' AND user_to='"+data.user_to+"' AND statu='HASTA') OR (user_id='"+data.user_to+"' AND user_to='"+data.user_id+"' AND statu='DOKTOR') ", function(err, rows) {
        if(err) throw err;
        for(var i = 0; i < rows.length; i++) {
            var row = rows[i];
            array.push(row);
            console.log(row);
        }
        console.log(array);
        client.emit("fetchMessages", array);
        client.emit("sonMesaj", array[rows.length - 1]);
      });
    } else {
      db.query("SELECT user_id, user_to, message, statu FROM `messages` WHERE (user_id='"+data.user_id+"' AND user_to='"+data.user_to+"' AND statu='DOKTOR') OR (user_id='"+data.user_to+"' AND user_to='"+data.user_id+"' AND statu='HASTA') ", function(err, rows) {
        if(err) throw err;
        for(var i = 0; i < rows.length; i++) {
            var row = rows[i];
            array.push(row);
        }
        console.log(array);
        client.emit("fetchMessages", array);
      });
    }
    
  })


  // On Typing... 
  client.on('is_typing', function(data) {
    if(data.status === true) {
       client.emit("typing", data);
       client.broadcast.emit('typing', data);
     } else {
       client.emit("typing", data);
       client.broadcast.emit('typing', data);
     }
  });

  client.on("disconnect", (data)=>{
    console.log("Bir kullanıcı çıkış yaptı.");
    //client.emit("disconnect", "");
  });
});

server.listen(4320);
