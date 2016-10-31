var app = require('express')();
var bodyParser = require('body-parser');

var resTxt = {
  type: "text"
};
var resBtn = {
  type: "buttons",
  "buttons": [
    "선택 1",
    "선택 2",
    "선택 3"
  ]
};
var resMsg = {
  "message": {
    "text":  "test message"
  }
}
var resMsgPhoto = {
  "message": {
    "text": "test message",
    "photo": {
      "url": "http://oi44.tinypic.com/28ssfah.jpg",
      "width": 640,
      "height": 480
    }
  }
}

app.set('port', (process.env.PORT || 5000));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/', function (req, res) {
  console.log(req.path);
  res.setHeader('Content-Type', 'application/json');
  res.json(resTxt);
});

app.get('/keyboard', function (req, res) {
  console.log(req.path);
  res.setHeader('Content-Type', 'application/json');
  res.json(resBtn);
});

app.post('/message', function (req, res) {
  console.log(req.path);
  console.log(req.body);
  res.setHeader('Content-Type', 'application/json');
  res.json(resMsg);
});

app.listen(app.get('port'), function () {
  console.log('bot is running on port', app.get('port'));
});
