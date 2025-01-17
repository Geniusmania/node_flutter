import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/create.dart';
import 'package:flutter_shop/pages/delete.dart';
import 'package:flutter_shop/pages/read.dart';
import 'package:flutter_shop/pages/update.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
          children:[
            ElevatedButton(onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Create()));}, child:const Text('create')),
            ElevatedButton(onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Read()));}, child:const Text('Read')),
            ElevatedButton(onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Update()));}, child:const Text('Update')),
            ElevatedButton(onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Delete()));}, child:const Text('delete')),
          ]
        ),
      )
      ),
    );
  }
}