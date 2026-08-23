function handler(event) {
  var request = event.request;
  var uri = request.uri;

  if (uri.endsWith('/') || !uri.includes('.')) {
      request.uri = '/index.html';
  }

  return request;
}