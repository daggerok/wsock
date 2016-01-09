var connect, disconnect, sendName, setConnected, showWelcome, stompClient;

stompClient = null;

setConnected = function(connected) {
  document.getElementById('connect').disabled = connected;
  document.getElementById('disconnect').disabled = !connected;
  if (connected) {
    document.getElementById('conversationDiv').style.visibility = 'visible';
  } else {
    document.getElementById('conversationDiv').style.visibility = 'hidden';
  }
  return document.getElementById('response').innerHTML = '';
};

connect = function() {
  var socket;
  socket = new SockJS('/welcome');
  stompClient = Stomp.over(socket);
  return stompClient.connect({}, function(frame) {
    setConnected(true);
    console.log("Connected: " + frame);
    return stompClient.subscribe('/topic/welcome', function(welcome) {
      return showWelcome(JSON.parse(welcome.body).content);
    });
  });
};

disconnect = function() {
  if (stompClient != null) {
    stompClient.disconnect();
  }
  setConnected(false);
  return console.log("Disconnected");
};

sendName = function() {
  var name;
  name = document.getElementById('name').value;
  stompClient.send("/app/welcome", {}, JSON.stringify({
    name: name
  }));
  return document.getElementById('name').value = '';
};

showWelcome = function(message) {
  var p, response;
  response = document.getElementById('response');
  p = document.createElement('p');
  p.style.wordWrap = 'break-word';
  p.appendChild(document.createTextNode(message));
  return response.appendChild(p);
};
