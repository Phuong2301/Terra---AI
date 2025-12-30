// ignore_for_file: public_member_api_docs, sort_constructors_first
class QAResponse {
  String body;
  int statusCode;
  String method;
  String url;
  dynamic headers;

  QAResponse({
    required this.body,
    this.statusCode = 200,
    this.method = "GET",
    this.url = '',
    this.headers,
  });
}
