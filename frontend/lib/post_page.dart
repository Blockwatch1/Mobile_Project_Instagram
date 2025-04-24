import 'package:flutter/material.dart';
import 'post.dart';
import 'User.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // User instances
  final User user1 = User("User 1", "https://www.google.com/imgres?q=ai%20person%20jpg&imgurl=https%3A%2F%2Fcdn.lucidpic.com%2Fcdn-cgi%2Fimage%2Fw%3D600%2Cformat%3Dauto%2Cmetadata%3Dnone%2F675703157f0da.png&imgrefurl=https%3A%2F%2Flucidpic.com%2F&docid=dC2HIqlL7ly1GM&tbnid=inVKXAe7V6iROM&vet=12ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECEwQAA..i&w=600&h=600&hcb=2&ved=2ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECEwQAA");
  final User user2 = User("User 2", "https://www.google.com/imgres?q=ai%20person%20jpg&imgurl=https%3A%2F%2Fkottke.org%2Fcdn-cgi%2Fimage%2Fformat%3Dauto%2Cfit%3Dscale-down%2Cwidth%3D1200%2Cmetadata%3Dnone%2Fplus%2Fmisc%2Fimages%2Fai-faces-01.jpg&imgrefurl=https%3A%2F%2Fkottke.org%2F18%2F12%2Fai-generated-human-faces-that-look-amazingly-real&docid=zVVuwhoBkcIpVM&tbnid=dgJamWU_KfRhUM&vet=12ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECDEQAA..i&w=849&h=849&hcb=2&ved=2ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECDEQAA");
  final User user3 = User("User 3", "https://www.google.com/imgres?q=ai%20person%20jpg&imgurl=https%3A%2F%2Fcdn.pixabay.com%2Fphoto%2F2024%2F03%2F31%2F05%2F00%2Fai-generated-8665996_1280.jpg&imgrefurl=https%3A%2F%2Fpixabay.com%2Fillustrations%2Fai-generated-indian-man-young-male-8665996%2F&docid=jntnjGArChuCxM&tbnid=gKzRoG3YG4ImVM&vet=12ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECE4QAA..i&w=958&h=1280&hcb=2&ved=2ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECE4QAA");
  final User user4 = User("User 4", "https://www.google.com/imgres?q=ai%20person%20jpg&imgurl=https%3A%2F%2Fimg.freepik.com%2Fpremium-photo%2Fportrait-happy-young-man-ai-generated_804788-34413.jpg&imgrefurl=https%3A%2F%2Fwww.freepik.com%2Fpremium-ai-image%2Fportrait-happy-young-man-ai-generated_65725337.htm&docid=zhka0W-QQe77tM&tbnid=JPWsETaayEV3OM&vet=12ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECHIQAA..i&w=626&h=626&hcb=2&ved=2ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECHIQAA");
  final User user5 = User("User 5", "https://www.google.com/imgres?q=ai%20person%20jpg&imgurl=https%3A%2F%2Fstatic.vecteezy.com%2Fsystem%2Fresources%2Fthumbnails%2F036%2F442%2F721%2Fsmall_2x%2Fai-generated-portrait-of-a-young-man-no-facial-expression-facing-the-camera-isolated-white-background-ai-generative-photo.jpg&imgrefurl=https%3A%2F%2Fwww.vecteezy.com%2Ffree-photos%2Fai-generated-man&docid=mced-E7J-ayyWM&tbnid=A4rrskdV78dBqM&vet=12ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECHkQAA..i&w=301&h=400&hcb=2&ved=2ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECHkQAA");
  final User user6 = User("User 6", "https://www.google.com/imgres?q=ai%20person%20jpg&imgurl=https%3A%2F%2Fcdn.prod.website-files.com%2F624ac40503a527cf47af4192%2F655c6883100932e9fcc96f7a_11.jpeg&imgrefurl=https%3A%2F%2Fwww.plugger.ai%2Ftasks%2Fai-person-generator&docid=-I201ya6HGJ3gM&tbnid=rLHbOB_7lYz8_M&vet=12ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECDkQAA..i&w=450&h=450&hcb=2&ved=2ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECDkQAA");
  final User user7 = User("User 7", "https://www.google.com/imgres?q=ai%20person%20jpg&imgurl=https%3A%2F%2Fcdn.lucidpic.com%2Fcdn-cgi%2Fimage%2Fw%3D600%2Cformat%3Dauto%2Cmetadata%3Dnone%2F66c43abe18502.png&imgrefurl=https%3A%2F%2Flucidpic.com%2F&docid=dC2HIqlL7ly1GM&tbnid=0OIzPFwXZ4vZQM&vet=12ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECGkQAA..i&w=600&h=728&hcb=2&ved=2ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECGkQAA");
  final User user8 = User("User 8", "https://www.google.com/imgres?q=profile%20picture%20.jpg&imgurl=https%3A%2F%2Fimg.freepik.com%2Fpremium-vector%2Favatar-profile-icon-flat-style-female-user-profile-vector-illustration-isolated-background-women-profile-sign-business-concept_157943-38866.jpg%3Fsemt%3Dais_hybrid%26w%3D740&imgrefurl=https%3A%2F%2Fwww.freepik.com%2Ffree-photos-vectors%2Fprofile&docid=WIYPytbMl_8XfM&tbnid=k8d3RtLsuhGNfM&vet=12ahUKEwiljLqzofGMAxXnhf0HHUWELtIQM3oECGcQAA..i&w=740&h=740&hcb=2&ved=2ahUKEwiljLqzofGMAxXnhf0HHUWELtIQM3oECGcQAA");

  // Comments map
 late final Map<User, String> userComments = {
   user1: "cool pic 🔥",
   user2: "nice 👍",
   user3: "❤️❤️",
  };

  // List of posts
  late final List<Post> list1 = [
    Post(user: user1, image: "https://www.google.com/imgres?q=ai%20person%20jpg&imgurl=https%3A%2F%2Fcdn.lucidpic.com%2Fcdn-cgi%2Fimage%2Fw%3D600%2Cformat%3Dauto%2Cmetadata%3Dnone%2F675703157f0da.png&imgrefurl=https%3A%2F%2Flucidpic.com%2F&docid=dC2HIqlL7ly1GM&tbnid=inVKXAe7V6iROM&vet=12ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECEwQAA..i&w=600&h=600&hcb=2&ved=2ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECEwQAA", comments: userComments, likeAmount: 359),
    Post(user: user2, image: "https://www.google.com/imgres?q=ai%20person%20jpg&imgurl=https%3A%2F%2Fkottke.org%2Fcdn-cgi%2Fimage%2Fformat%3Dauto%2Cfit%3Dscale-down%2Cwidth%3D1200%2Cmetadata%3Dnone%2Fplus%2Fmisc%2Fimages%2Fai-faces-01.jpg&imgrefurl=https%3A%2F%2Fkottke.org%2F18%2F12%2Fai-generated-human-faces-that-look-amazingly-real&docid=zVVuwhoBkcIpVM&tbnid=dgJamWU_KfRhUM&vet=12ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECDEQAA..i&w=849&h=849&hcb=2&ved=2ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECDEQAA", comments: userComments, likeAmount: 100),
    Post(user: user3, image: "https://www.google.com/imgres?q=ai%20person%20jpg&imgurl=https%3A%2F%2Fcdn.pixabay.com%2Fphoto%2F2024%2F03%2F31%2F05%2F00%2Fai-generated-8665996_1280.jpg&imgrefurl=https%3A%2F%2Fpixabay.com%2Fillustrations%2Fai-generated-indian-man-young-male-8665996%2F&docid=jntnjGArChuCxM&tbnid=gKzRoG3YG4ImVM&vet=12ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECE4QAA..i&w=958&h=1280&hcb=2&ved=2ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECE4QAA", comments: userComments, likeAmount: 87),
    Post(user: user4, image: "https://www.google.com/imgres?q=ai%20person%20jpg&imgurl=https%3A%2F%2Fimg.freepik.com%2Fpremium-photo%2Fportrait-happy-young-man-ai-generated_804788-34413.jpg&imgrefurl=https%3A%2F%2Fwww.freepik.com%2Fpremium-ai-image%2Fportrait-happy-young-man-ai-generated_65725337.htm&docid=zhka0W-QQe77tM&tbnid=JPWsETaayEV3OM&vet=12ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECHIQAA..i&w=626&h=626&hcb=2&ved=2ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECHIQAA", comments: userComments, likeAmount: 43),
    Post(user: user5, image: "https://www.google.com/imgres?q=ai%20person%20jpg&imgurl=https%3A%2F%2Fstatic.vecteezy.com%2Fsystem%2Fresources%2Fthumbnails%2F036%2F442%2F721%2Fsmall_2x%2Fai-generated-portrait-of-a-young-man-no-facial-expression-facing-the-camera-isolated-white-background-ai-generative-photo.jpg&imgrefurl=https%3A%2F%2Fwww.vecteezy.com%2Ffree-photos%2Fai-generated-man&docid=mced-E7J-ayyWM&tbnid=A4rrskdV78dBqM&vet=12ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECHkQAA..i&w=301&h=400&hcb=2&ved=2ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECHkQAA", comments: userComments, likeAmount: 328),
    Post(user: user6, image: "https://www.google.com/imgres?q=ai%20person%20jpg&imgurl=https%3A%2F%2Fcdn.prod.website-files.com%2F624ac40503a527cf47af4192%2F655c6883100932e9fcc96f7a_11.jpeg&imgrefurl=https%3A%2F%2Fwww.plugger.ai%2Ftasks%2Fai-person-generator&docid=-I201ya6HGJ3gM&tbnid=rLHbOB_7lYz8_M&vet=12ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECDkQAA..i&w=450&h=450&hcb=2&ved=2ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECDkQAA", comments: userComments, likeAmount: 56),
    Post(user: user7, image: "https://www.google.com/imgres?q=ai%20person%20jpg&imgurl=https%3A%2F%2Fcdn.lucidpic.com%2Fcdn-cgi%2Fimage%2Fw%3D600%2Cformat%3Dauto%2Cmetadata%3Dnone%2F66c43abe18502.png&imgrefurl=https%3A%2F%2Flucidpic.com%2F&docid=dC2HIqlL7ly1GM&tbnid=0OIzPFwXZ4vZQM&vet=12ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECGkQAA..i&w=600&h=728&hcb=2&ved=2ahUKEwjGi8-1ovGMAxVzgP0HHZUGCX4QM3oECGkQAA", comments: userComments, likeAmount: 108),
    Post(user: user8, image: "https://www.google.com/imgres?q=profile%20picture%20.jpg&imgurl=https%3A%2F%2Fimg.freepik.com%2Fpremium-vector%2Favatar-profile-icon-flat-style-female-user-profile-vector-illustration-isolated-background-women-profile-sign-business-concept_157943-38866.jpg%3Fsemt%3Dais_hybrid%26w%3D740&imgrefurl=https%3A%2F%2Fwww.freepik.com%2Ffree-photos-vectors%2Fprofile&docid=WIYPytbMl_8XfM&tbnid=k8d3RtLsuhGNfM&vet=12ahUKEwiljLqzofGMAxXnhf0HHUWELtIQM3oECGcQAA..i&w=740&h=740&hcb=2&ved=2ahUKEwiljLqzofGMAxXnhf0HHUWELtIQM3oECGcQAA", comments: userComments, likeAmount: 99),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list1.length,
        itemBuilder: (context, index) {
          return list1 [index];
        },
      );
  }
}