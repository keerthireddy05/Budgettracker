import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:budget_tracking/models/pie_data.dart';
import 'package:budget_tracking/models/transaction.dart';
import 'package:budget_tracking/screens/statistics/pie_chart.dart';
import 'package:budget_tracking/widgets/no_trancaction.dart';
import 'package:budget_tracking/widgets/transaction_list_items.dart';

class DailyBudgeting extends StatefulWidget {
  @override
  _DailyBudgetingState createState() => _DailyBudgetingState();
}

class _DailyBudgetingState extends State<DailyBudgeting> {
  bool _showChart = false;
  Transactions trxData;
  Function deleteFn;

  @override
  void initState() {
    super.initState();
    trxData = Provider.of<Transactions>(context, listen: false);

    deleteFn =
        Provider.of<Transactions>(context, listen: false).deleteTransaction;
  }

  @override
  Widget build(BuildContext context) {
    final dailyTrans = Provider.of<Transactions>(context).dailyTransactions();

    final List<PieData> dailyData = PieData().pieChartData(dailyTrans);

    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(
                  right: 15, top: 10, bottom: 10, left: 15),
              color: Theme.of(context).primaryColorLight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "₹${trxData.getTotal(dailyTrans)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Show Chart',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Switch.adaptive(
                        activeColor: Theme.of(context).accentColor,
                        value: _showChart,
                        onChanged: (val) {
                          setState(() {
                            _showChart = val;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              )),
          dailyTrans.isEmpty
              ? NoTransactions()
              : (_showChart
                  ? MyPieChart(pieData: dailyData)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return TransactionListItems(
                            trx: dailyTrans[index], dltTrxItem: deleteFn);
                      },
                      itemCount: dailyTrans.length,
                    ))
        ],
      ),
    );
  }
}
