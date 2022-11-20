// Flutter imports:
import 'package:flutter/material.dart';

class RadioWidget extends StatefulWidget {
  final dynamic index;
  final bool isSelected;
  final VoidCallback onSelect;
  final String headline;

  const RadioWidget({
    Key key,
    @required this.index,
    @required this.isSelected,
    @required this.onSelect,
    @required this.headline,
  })  : assert(index != null),
        assert(isSelected != null),
        assert(onSelect != null),
        super(key: key);

  @override
  _RadioWidgetState createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelect,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 30.0,
          width: 30.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: <Widget>[
              Image.asset(
                widget.isSelected
                    ? 'mages/addhw.png'
                    : 'assets/images/myroutine.png',
                width: 30.0,
                height: 30.0,
              ),
              SizedBox(
                width: 2.0,
              ),
              Text(
                widget.headline,
                style: TextStyle(
                  color: widget.isSelected ? Colors.deepPurple : Colors.grey,
                  fontSize: 10.0,
                ),
                maxLines: 1,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
