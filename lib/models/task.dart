class Task {

  final String title;
  final String description;
  final String timestamp;
  final String time;


  Task({

    this.title,
    this.description,
    this.time,
this
  .timestamp
  });

  Map<String, dynamic> toMap() {
    return {

      'title': title,
      'description': description,
'timestamp':timestamp,
      'time':time
    };
  }
}
