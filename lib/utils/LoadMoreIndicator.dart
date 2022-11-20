import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:loading_more_list/loading_more_list.dart';

class BuildIndicatorBuilder {
  final dynamic source;
  final bool isSliver;
  final String name;

  BuildIndicatorBuilder({this.source, this.isSliver, this.name});

  Widget buildIndicator(BuildContext context, IndicatorStatus status) {
    Widget widget;
    switch (status) {
      case IndicatorStatus.none:
        widget = Container(height: 0.0);
        break;
      case IndicatorStatus.loadingMoreBusying:
        widget = Center(
            child: SizedBox(width: 50.w, child: CupertinoActivityIndicator()));
        break;
      case IndicatorStatus.fullScreenBusying:
        widget = Container(
          margin: EdgeInsets.only(right: 0.0),
          child: Center(child: CupertinoActivityIndicator()),
        );
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case IndicatorStatus.error:
        widget = Text('Error', style: Get.theme.textTheme.headline6);

        widget = GestureDetector(
          onTap: () {
            source.errorRefresh();
          },
          child: widget,
        );

        break;
      case IndicatorStatus.fullScreenError:
        widget = ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: 30.h,
            ),
            Image.asset(
              AppConfig.appLogo,
              width: 30.w,
              height: 30.h,
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              '- Error getting data - ',
              style: Get.textTheme.subtitle2,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0.w),
              child: ElevatedButton(
                onPressed: () {
                  source.errorRefresh();
                },
                child: Text("Reload"),
              ),
            ),
          ],
        );
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case IndicatorStatus.noMoreLoad:
        widget = SizedBox.shrink();
        break;
      case IndicatorStatus.empty:
        widget = ListView(
          children: <Widget>[
            SizedBox(
              height: 30.h,
            ),
            Text(
              '$name',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        );
        if (isSliver) {
          widget = SliverToBoxAdapter(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
    }
    return widget;
  }
}
