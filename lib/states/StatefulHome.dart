import 'package:chard_flutter/components/Modelo.dart';
import 'package:chard_flutter/util/util.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_svg/flutter_svg.dart';

class StatefulHome extends StatefulWidget {
  const StatefulHome({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<StatefulHome> {
  final List<charts.Series<ChartData, String>> seriesList = [
    charts.Series<ChartData, String>(
      id: 'Sales',
      domainFn: (ChartData sales, _) => sales.label,
      measureFn: (ChartData sales, _) => sales.value,
      colorFn: (ChartData sales, _) =>
        sales.value < 0 ?
        charts.ColorUtil.fromDartColor(Colors.red[400]!) :
        charts.ColorUtil.fromDartColor(Colors.green),
      data: [
        ChartData(label: 'Jan', value: -500),
        ChartData(label: 'Feb', value: 750),
        ChartData(label: 'Mar', value: -1000),
        ChartData(label: 'Apr', value: 650),
        ChartData(label: 'Mai', value: 1000),
        ChartData(label: 'Jun', value: -650),
      ],
    ),
  ];

  Future<void> verificaLogado() async {
    var statusLogado = await Persist.hasToken();

    print(statusLogado);

    if (!statusLogado){
      Navigator.of(context).popUntil(ModalRoute.withName('Login'));
    }
  }

  @override
  void initState() {
    super.initState();
    verificaLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Modelo(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Dados dos últimos meses',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Expanded(
                        child: charts.BarChart(
                          seriesList,
                          animate: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Transações env. (mês)',
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Text(
                            //   title,
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 18.0,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                Text(
                                  'quant: ',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('5', style: TextStyle(fontSize: 14.0),)
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'R\$464.93',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Transações rec. (mês)',
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Text(
                            //   title,
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 18.0,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            const SizedBox(height: 12.0),
                            const Row(
                              children: [
                                Text(
                                  'quant: ',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('9', style: TextStyle(fontSize: 14.0),)
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'R\$512.52',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.red[400]!,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Saldo final do mês',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Text(
                      //   title,
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 18.0,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      const SizedBox(height: 18.0),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.70,
                            child: const Text(
                              '+R\$53.12 em relação com o mês passado',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                            child: const Icon(Icons.arrow_upward, color: Colors.blueAccent,)
                          )
                        ],
                      ),
                      const SizedBox(height: 14.0),
                      const Center(
                        child: Text(
                          '+R\$241.27',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ),
          ],
        ),
      ),
      setStateParent: () {
        setState(() {
        });
      },
    );
  }
}

class ChartData {
  final String label;
  final int value;

  ChartData({required this.label, required this.value});
}