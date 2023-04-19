
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:netflix/data/entry.dart';
import 'package:provider/provider.dart';

import '../providers/entry.dart';
import '../providers/watchlist.dart';
import '../widgets/buttons/icon.dart';
class DetailsScreen extends StatefulWidget {
  final Entry _entry;
  const DetailsScreen({Key? key,required Entry entry}) :_entry=entry, super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DetailHeader(featured:widget._entry),
          const SizedBox(height: 20,),

          Expanded(child: Padding(
            padding: const EdgeInsets.fromLTRB(20,0,20,0),
            child: Text(
              widget._entry.description ?? "",
              style: const TextStyle(fontSize: 14,color: Colors.white),
            ),
          )),
          const SizedBox(height: 20,),
          Expanded(child: Padding(
            padding: const EdgeInsets.fromLTRB(20,0,20,0),
            child: Text(
              "Starring: ${widget._entry.cast}",
              style: const TextStyle(fontSize: 12,color: Colors.white),
            ),
          )),
          const Spacer(),
          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              VerticalIconButton(
                  icon: context.read<WatchListProvider>().isOnList(widget._entry)
                      ? Icons.check
                      :Icons.add,
                  title: 'My List',
                  tap: (){
                    if(context.read<WatchListProvider>().isOnList(widget._entry)){
                      context.read<WatchListProvider>().remove(widget._entry);
                    }else{
                      context.read<WatchListProvider>().add(widget._entry);
                    }
                    Navigator.of(context).pop();
                  }),
              const Spacer(),
              VerticalIconButton(icon: Icons.thumb_up, title: 'Rate', tap: (){}),
              const Spacer(),
              VerticalIconButton(icon: Icons.share, title: 'Share', tap: (){}),
              const Spacer(),
            ],
          ))
        ],
      ),
    );
  }

}
class _DetailHeader extends StatelessWidget{
  final Entry featured;
  const _DetailHeader({Key? key, required this.featured}):super(key:key);

  @override
  Widget build(BuildContext context){
    return  FutureBuilder(
      future: context.read<EntryProvider>().imageFor(featured),
      builder: (context, snapshot) {
        if(snapshot.hasData==false || snapshot.data==null){
          return const SizedBox(
            height: 500,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Stack(
          fit: StackFit.passthrough,
          alignment: Alignment.center,
          children: [
            Container(
              height: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.memory(snapshot.data!).image,
                ),
              ),
              child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 20,sigmaY: 20),
                child: Container(
                  height: 500,
                  decoration: const BoxDecoration(color: Colors.black),
                ),),
            )
          ],
        );
      },);
  }

}