class EmailModel {
  bool isStarred;
  bool hasRead;
  final String sender;
  final String subject;
  final String body;
  final DateTime timestamp;

  EmailModel({
    this.isStarred = false,
    this.hasRead = false,
    required this.sender,
    required this.subject,
    required this.body,
    required this.timestamp,
  });
}

final emailList = <EmailModel>[
  EmailModel(
    sender: "Albert Flores Store",
    subject: "Whimsical Wedding Graphics to Design Your",
    body: "Lorem Ipsum is simply dummy text of the printing and",
    timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 10)),
  ),
  EmailModel(
    sender: "Albert Flores Store",
    subject: "Graphics Design ",
    body: "Lorem Ipsum is simply dummy text of the printing and",
    timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
  ),
  EmailModel(
    sender: "Jane Cooper Store",
    subject: "lorem ipsum Email subject ",
    body: "Lorem Ipsum is simply dummy text of the printing and",
    timestamp: DateTime(2024, 07, 12, 12, 20),
    hasRead: true,
  ),
  EmailModel(
    sender: "Jane Cooper Store",
    subject: "Email subject lorem ipsum",
    body: "Lorem Ipsum is simply dummy text of the printing and",
    timestamp: DateTime(2024, 07, 10, 12, 36),
    isStarred: true,
  ),
  EmailModel(
    sender: "Jane Cooper Store",
    subject: "Email subject lorem ipsum",
    body: "Lorem Ipsum is simply dummy text of the printing and",
    timestamp: DateTime(2024, 07, 07, 12, 36),
    isStarred: true,
  ),
  EmailModel(
    sender: "Jane Cooper Store",
    subject: "Email subject lorem ipsum",
    body: "Lorem Ipsum is simply dummy text of the printing and",
    timestamp: DateTime(2024, 07, 07, 12, 36),
    hasRead: true,
  ),
  EmailModel(
    sender: "Jane Cooper Store",
    subject: "Email subject lorem ipsum",
    body: "Lorem Ipsum is simply dummy text of the printing and",
    timestamp: DateTime(2024, 07, 06, 12, 36),
  ),
  EmailModel(
    sender: "Jane Cooper Store",
    subject: "Email subject lorem ipsum",
    body: "Lorem Ipsum is simply dummy text of the printing and",
    timestamp: DateTime(2024, 07, 06, 12, 36),
  ),
  EmailModel(
    sender: "Jane Cooper Store",
    subject: "Email subject lorem ipsum",
    body: "Lorem Ipsum is simply dummy text of the printing and",
    timestamp: DateTime(2024, 07, 05, 12, 36),
  ),
  EmailModel(
    sender: "Jane Cooper Store",
    subject: "Email subject lorem ipsum",
    body: "Lorem Ipsum is simply dummy text of the printing and",
    timestamp: DateTime(2024, 07, 04, 12, 36),
  ),
  EmailModel(
    sender: "Jane Cooper Store",
    subject: "Email subject lorem ipsum",
    body: "Lorem Ipsum is simply dummy text of the printing and",
    timestamp: DateTime(2024, 07, 04, 12, 36),
  ),
  EmailModel(
    sender: "Jane Cooper Store",
    subject: "Email subject lorem ipsum",
    body: "Lorem Ipsum is simply dummy text of the printing and",
    timestamp: DateTime(2024, 07, 03, 12, 36),
  ),
];
