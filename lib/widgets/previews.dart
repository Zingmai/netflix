
import 'package:flutter/material.dart';
import 'package:netflix/data/entry.dart';
import 'package:netflix/providers/entry.dart';
import 'package:netflix/screens/details.dart';
import 'package:provider/provider.dart';

class Previews extends StatefulWidget {
  final String title;

  const Previews({Key? key,required this.title});

  @override
  State<Previews> createState() => _PreviewsState();
}

class _PreviewsState extends State<Previews> {
  Widget _renderStack(Entry entry) {
    return FutureBuilder(
      future: context.read<EntryProvider>().imageFor(entry),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 130,
            width: 130,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            snapshot.hasData && snapshot.data != null
                ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image
                        .memory(snapshot.data!)
                        .image,
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withAlpha(40), width: 4
                  )
              ),
            ) : const CircularProgressIndicator(),
            Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Colors.black87,
                    Colors.black45,
                    Colors.transparent
                  ], stops: [
                    0,
                    0.25,
                    1,
                  ], begin: Alignment.bottomCenter,
                      end: Alignment.topCenter),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withAlpha(40), width: 4)
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: SizedBox(
                  height: 60,
                  child: Text(
                    entry.name.length > 14
                        ? entry.name.substring(0, 14)
                        : entry.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                    ),
                  ),),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context){
    var entries=context.read<EntryProvider>().entries;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(left: 30),
        child: Text(
          'Popular this week',
          style: TextStyle(color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20),
        ),),
        SizedBox(
          height: 165,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
              itemCount: entries.length,
              itemBuilder: (BuildContext context,int index) {
                final Entry entry=entries[index];
                return GestureDetector(
                  onTap: ()async{
                    await showDialog(context: context, builder: (context) =>
                     DetailsScreen(entry: entry) ,);
                  },
                  child: _renderStack(entry),
                );
              },),
        )
      ],
    );
  }
}

