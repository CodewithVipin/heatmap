import 'package:flutter/material.dart';

// Widget to display summary details at the top
class SummaryDetails extends StatelessWidget {
  final double targetAmount;
  final double totalInvestment;
  final double avgProfit;
  final double avgProfitPercent;
  final double totalProfit;

  final double coverTarget;

  const SummaryDetails({
    super.key,
    required this.coverTarget,
    required this.targetAmount,
    required this.totalInvestment,
    required this.totalProfit,
    required this.avgProfit,
    required this.avgProfitPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        10,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Target Amount",
                style: TextStyle(
                    color: Colors.grey.shade400, fontWeight: FontWeight.w400),
              ),
              Text("${targetAmount.toStringAsFixed(2)} Rs.",
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold)),
              Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          totalProfit >= 0 ? Colors.green : Colors.deepOrange),
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "${coverTarget.toStringAsFixed(2)}%",
                  style: TextStyle(
                      color: totalProfit > 0 ? Colors.green : Colors.deepOrange,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Investment",
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400)),
              Text("${totalInvestment.toStringAsFixed(2)} Rs.",
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "P/L Percentage",
                  style: TextStyle(
                      color: Colors.grey.shade400, fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color:
                          totalProfit >= 0 ? Colors.green : Colors.deepOrange),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade800,
                      ),
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Text(
                        textAlign: TextAlign.center,
                        "${avgProfitPercent.toStringAsFixed(2)} %",
                        style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 10,
                            color: totalProfit >= 0
                                ? Colors.green
                                : Colors.deepOrange),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total P/L",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Text(
                  "${totalProfit.toStringAsFixed(2)} Rs.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          totalProfit > 0 ? Colors.green : Colors.deepOrange),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
