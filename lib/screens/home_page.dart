import 'package:expense_manager/screens/category_page.dart';
import 'package:expense_manager/screens/dahboard_page.dart';
import 'package:expense_manager/screens/report_page.dart';
import 'package:flutter/material.dart';
import 'income_page.dart';
import 'income2_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<String> _tabs = ["Home", "Category", "Income", "Budget", "Reports"];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: _tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Control de Gastos"),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.trending_down)),
              Tab(icon: Icon(Icons.category)),
              Tab(icon: Icon(Icons.monetization_on)),
              Tab(icon: Icon(Icons.mode_edit)),
              Tab(icon: Icon(Icons.donut_small)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            DashboardPage(),
            CategoryPage(),
            IncomePage(),
            Income2Page(),
            ChartsDemo()
          ],
        ));
  }
}
