import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class OverView extends StatefulWidget {
  const OverView({super.key});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  final double percentage = 70.0;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffF3ECFB),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: w * 0.8,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Project Status",
                          style: TextStyle(
                              color: Color(0xff16192C),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              fontFamily: 'Inter',
                              height: 24 / 15),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        PieChart(
                          dataMap: {
                            "Progress": percentage,
                          },

                          animationDuration: Duration(milliseconds: 600),
                          chartType: ChartType.ring,
                          ringStrokeWidth: 16,
                          // centerText:
                          baseChartColor: Color(0xffE0C6FD),
                          // chartRadius: ,

                          chartValuesOptions: ChartValuesOptions(
                            chartValueStyle: TextStyle(
                                color: Color(0xff682FA3),
                                fontFamily: 'Inter',
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                            showChartValuesOutside: false,
                            showChartValuesInPercentage: true,
                            decimalPlaces: 1,
                          ),
                          totalValue: 100, // Total value for the chart
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
