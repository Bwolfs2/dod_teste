import 'dart:io';
import 'package:dod/2-business/blocs/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = HomeBloc();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 4, color: Color(0xff29AFC2)),
            ),
            //color: Colors.greenAccent,
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .7,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                StreamBuilder<File>(
                  stream: bloc.fileStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot == null || snapshot.data == null) {
                      return Center(
                        child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height * .6,
                            child: Center(
                              child: Text(
                                "Nenhuma imagem carregada.",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text("${snapshot.error}"),
                      );
                    }

                    return Container(
                      child: Image.file(
                        snapshot.data,
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: StreamBuilder<bool>(
                    stream: bloc.loading,
                    builder: (context, snapshot) {
                      if (snapshot == null ||
                          snapshot.data == null ||
                          !snapshot.data) {
                        return SizedBox();
                      }
                      return Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            height: 20,
                            child: LinearProgressIndicator(
                              backgroundColor: Color(0xff29AFC2),
                            ),
                            width: MediaQuery.of(context).size.width * .8,
                          ),
                          Positioned(
                            child: StreamBuilder<int>(
                                stream: bloc.downloadProgress,
                                builder: (context, snapshot) {
                                  if (snapshot == null ||
                                      snapshot.data == null) {
                                    return Text(
                                      "Carregando..",
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    );
                                  }

                                  if (snapshot.hasError) {
                                    return Text("${snapshot.error}");
                                  }

                                  return Text(
                                    "Analisando ${snapshot.data}%",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  );
                                }),
                            top: 5,
                            left: 0,
                            right: 0,
                          )
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xff2D2D2D),
      bottomNavigationBar: Stack(
        children: <Widget>[
          CurvedNavigationBar(
            color: Color(0xff29AFC2),
            backgroundColor: Color(0xff2D2D2D),
            items: <Widget>[
              Icon(
                Icons.camera,
                size: 40,
                color: Colors.white,
              ),
            ],
            onTap: (index) {
              bloc.getImage();
            },
          )
        ],
      ),
    );
  }
}
