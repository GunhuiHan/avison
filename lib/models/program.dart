class Program {
  final int id;
  final String title;
  final String image;
  final String ra;
  final List<dynamic> date;
  final List<dynamic> formattedDate;
  final String time;
  final String location;
  final int points;
  final int personnel;
  final String googleForm;
  final String intro;

  Program(
      {this.id,
      this.title,
      this.image,
      this.ra,
      this.date,
      this.formattedDate,
      this.time,
      this.location,
      this.points,
      this.personnel,
      this.googleForm,
      this.intro});
}

//convert list of timestamp form firebase to list of formatted date type
//List<dynamic> programDate = snapshot.data;
//int length = programDate.length;
//for (int i = 0; i < length; i++) {
//programDate[i] = DateFormat('M-dd').format(programDate[i].toDate());
//}
