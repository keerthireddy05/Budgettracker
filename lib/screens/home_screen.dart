import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/transaction.dart';
import './transactions/daily_budgeting.dart';
import './transactions/monthly_budgeting.dart';
import './new_budgeting.dart';
import './transactions/weekly_budgeting.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Budget Tracker",
          style: Theme.of(context).appBarTheme.textTheme.headline1,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(NewBudget.routeName)),
        ],
        bottom: new TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,
          indicatorColor: Theme.of(context).primaryColorDark,
          tabs: <Widget>[
            new Tab(
              text: "Daily",
            ),
            new Tab(
              text: "Weekly",
            ),
            new Tab(
              text: 'Monthly',
            ),
          ],
          controller: tabController,
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<Transactions>(context, listen: false)
            .fetchTransactions(),
        builder: (ctx, snapshot) =>
            (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: CircularProgressIndicator())
                : TabBarView(
                    children: <Widget>[
                      new DailyBudgeting(),
                      new WeeklyBudgeting(),
                      new MonthlyBudgeting(),
                    ],
                    controller: tabController,
                  ),
      ),
    );
  }
}
