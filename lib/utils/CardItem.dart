// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class CustomWidget extends StatefulWidget {
  final int index;
  final bool isSelected;
  final VoidCallback onSelect;
  final String headline;
  final String icon;

  const CustomWidget({
    Key key,
    @required this.index,
    @required this.isSelected,
    @required this.onSelect,
    @required this.headline,
    @required this.icon,
  })  : assert(index != null),
        assert(isSelected != null),
        assert(onSelect != null),
        super(key: key);

  @override
  _CustomWidgetState createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelect,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 100.0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color:
                    widget.isSelected ? Color(0xffc8abfc) : Color(0xFF93CFC4),
                blurRadius: 10.0,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: widget.isSelected
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF93CFC4), Color(0xFFF39EAA)])
                  : LinearGradient(colors: [Colors.white, Colors.white]),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset(
                  widget.icon.toString(),
                  color: widget.isSelected ? Colors.white : Color(0xFFF39EAA),
                  width: 35.w,
                  height: 35.h,
                ),
                Text(
                  widget.headline.tr,
                  style: TextStyle(
                    color: widget.isSelected ? Colors.white : Colors.grey,
                    fontSize: ScreenUtil().setSp(12),
                    fontWeight: FontWeight.w500,
                  ),
                  // maxLines: 1,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
