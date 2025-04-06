import 'package:enviroewatch/helper/route_helper.dart';
import 'package:enviroewatch/provider/report_provider.dart';
import 'package:enviroewatch/view/base/custom_app_bar.dart';
import 'package:enviroewatch/view/screens/home/widget/report_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enviroewatch/provider/auth_provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    final bool _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<ReportProvider>(context, listen: false)
          .getreportList(context);
    }

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: CustomAppBar(
          title: 'Reports',
          isBackButtonExist: true,
          onBackPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, RouteHelper.getHomeRoute(), (route) => false);
          },
        ),
        
        body: SafeArea(
            child:Scrollbar(
                    child: Center(
                    child: SizedBox(
                      width: 1170,
                      child: Consumer<ReportProvider>(
                        builder: (context, reportProvider, child) =>
                            reportProvider.historyList != null
                                ? Column(
                                    children: [Expanded(child: ReportView())],
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Theme.of(context).primaryColor))),
                      ),
                    ),
                  ))
                ));
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
