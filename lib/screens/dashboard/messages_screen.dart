import 'dart:async';

import 'package:curae/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  final List messages;
  const MessagesScreen({super.key, required this.messages});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  ScrollController _scrollController = new ScrollController();
  bool _firstAutoscrollExecuted = false;
  bool _shouldAutoscroll = false;

  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void _scrollListener() {
    _firstAutoscrollExecuted = true;

    if (_scrollController.hasClients &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      _shouldAutoscroll = true;
    } else {
      _shouldAutoscroll = false;
    }
  }

  Timer? timer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    timer = Timer.periodic(
        Duration(milliseconds: 100), (Timer t) => triggerFunction());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    timer?.cancel();
    super.dispose();
  }

  void triggerFunction() {
    setState(() {
      if (_scrollController.hasClients && _shouldAutoscroll) {
        _scrollToBottom();
      }

      if (!_firstAutoscrollExecuted && _scrollController.hasClients) {
        _scrollToBottom();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return ListView.separated(
      controller: _scrollController,
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 8),
          child: Row(
            mainAxisAlignment: widget.messages[index]['isUserMessage']
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                    topRight: widget.messages[index]['isUserMessage']
                        ? Radius.circular(0)
                        : Radius.circular(8),
                    topLeft: widget.messages[index]['isUserMessage']
                        ? Radius.circular(8)
                        : Radius.circular(0),
                  ),
                  color: widget.messages[index]['isUserMessage']
                      ? secondaryColor
                      : Colors.white,
                ),
                constraints: BoxConstraints(maxWidth: w * 2 / 3),
                child: Text(
                  widget.messages[index]['message'].text.text[0],
                  style: TextStyle(
                      color: widget.messages[index]['isUserMessage']
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Padding(padding: EdgeInsets.only(bottom: 0));
      },
    );
  }
}
