import 'package:flutter/material.dart';
import '../Models/User.dart';

class Thread extends StatefulWidget {
  User user;
  Map<User,String>comments;
  int likeAmount;
  Thread({super.key,required this.user,required this.comments,required this.likeAmount});
  @override
  State<Thread> createState() => _ThreadState();
}
String porthavenText = "The village of Porthaven nestled beside the whispering willow creek, a place where the air always smelled faintly of brine and woodsmoke. Generations of seafaring folk had carved their lives into the craggy coastline, their days dictated by the tides and the moods of the temperamental Azure Sea. Cobblestone paths wound between houses built from weathered stone, their roofs adorned with seashells and the occasional bleached whalebone. Old Man Tiber, the village's self-proclaimed historian (though his tales often stretched further than any fishing net), claimed that Porthaven was built upon the petrified remains of a giant sea serpent, its slumbering form still influencing the strange currents offshore.\\nThe inhabitants of Porthaven were as unique as their surroundings. There was Elara, the baker whose sourdough loaves tasted inexplicably of the sea, and Finnigan, the lighthouse keeper who communicated primarily through elaborate seagull calls. Young Maeve, with her uncanny ability to find lost trinkets in the sand dunes, was often sought after by frantic tourists who'd misplaced their spectacles or souvenir spoons. And then there were the Whispering Willows themselves, lining the creek bank. Legend had it that they carried the secrets of the village, their leaves rustling with forgotten stories and prophecies that only the truly attuned could understand.\\nOne particularly blustery autumn, a peculiar event stirred the quiet rhythm of Porthaven. A collection of luminous, orb-like creatures began appearing along the shoreline at dusk. They pulsed with a soft, ethereal light, casting an otherworldly glow on the sand and the crashing waves. Some villagers were frightened, whispering of ancient sea spirits and ill omens. Others, like young Maeve, were captivated by their beauty, spending hours observing their gentle undulations. Old Man Tiber, of course, had a fantastical explanation involving bioluminescent plankton brought in by a rare southern current and the tears of a lovesick mermaid.\\n";
class _ThreadState extends State<Thread> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width : double.infinity,
      child: Expanded(
        child: Column(
          children: [
            Container(
              height: 100,
              child: Expanded(child: Row(
                children: [
                  SizedBox(width:20),
                  CircleAvatar(backgroundImage: NetworkImage(widget.user.pfpPath!),radius: 20,),
                  SizedBox(width:40),
                  Text(widget.user.username)
                ],
              )),
            ),
            ThreadText(text: porthavenText),
            Container(
              height: 100,
              child: Expanded(
                child: Row(
                  spacing: 100,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border),
                        Text(widget.likeAmount.toString())
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.comment_rounded),
                        Text(widget.comments.length.toString())
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.share),
                        Text("share")
                      ],
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ThreadText extends StatefulWidget {
  String text;
  ThreadText({super.key,required this.text});

  @override
  State<ThreadText> createState() => _ThreadTextState();
}

class _ThreadTextState extends State<ThreadText> {
  bool showAll=false;
  @override
  Widget build(BuildContext context) {
    if(widget.text.length<200){
      return Container(width: double.infinity,
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),

        child: Text(widget.text),
      );
    }
    if(showAll) {
      return Container(width: double.infinity,
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
        child: Column(
          children: [
            Text(widget.text),
            GestureDetector(
              onTap: (){
                setState(() {
                  showAll=!showAll;
                });
              },
              child: Text("Show less", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold ),),
            )
          ],
        ),
      );
    }else{
      return Container(width: double.infinity,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
          child: Column(
            children: [
              Text(widget.text.substring(0,200)),
              GestureDetector(
                onTap: (){
                  setState(() {
                    showAll=!showAll;
                  });
                },
                child: Text("Show more", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold ),),
              )
            ],
          )
      );
    }
  }
}

