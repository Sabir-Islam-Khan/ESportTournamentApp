import 'dart:math';

import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('UPI Pay'),
        ),
        body: Screen(),
      ),
    );
  }
}

class Screen extends StatefulWidget {
  final String amount, address;
  Screen([this.amount, this.address]);
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  String _upiAddrError;

  final _upiAddressController = TextEditingController();
  final _amountController = TextEditingController();

  bool _isUpiEditable = false;
  Future<List<ApplicationMeta>> _appsFuture;

  @override
  void initState() {
    super.initState();

    _appsFuture = UpiPay.getInstalledUpiApplications();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _upiAddressController.dispose();
    super.dispose();
  }

  void _generateAmount() {
    setState(() {
      _amountController.text =
          (Random.secure().nextDouble() * 10).toStringAsFixed(2);
    });
  }

  Future<void> _onTap(ApplicationMeta app) async {
    final err = _validateUpiAddress(_upiAddressController.text);
    if (err != null) {
      setState(() {
        _upiAddrError = err;
      });
      return;
    }
    setState(() {
      _upiAddrError = null;
    });

    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    print("Starting transaction with id $transactionRef");

    final a = await UpiPay.initiateTransaction(
      amount: widget.amount.toString(),
      app: app.upiApplication,
      receiverName: 'Lobby of Games',
      receiverUpiAddress: widget.address.toString(),
      transactionRef: transactionRef,
      merchantCode: '7372',
    );

    print(a);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(30, 31, 45, .97),
          title: Center(child: Text("Payment")),
        ),
        body: Container(
          color: Color.fromRGBO(30, 31, 45, 1),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Center(
                child: Text(
                  "Pay ${widget.amount} Inr to 8309918013@upi",
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              GestureDetector(
                onTap: () {
                  // Fluttertoast.showToast(msg: "You can't change Address");
                },
                child: Container(
                  margin: EdgeInsets.only(top: 32),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          color: Color.fromRGBO(93, 83, 207, 1),
                          child: TextFormField(
                            enabled: true,
                            controller: _upiAddressController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Type here (8309918013@upi)',
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (_upiAddrError != null)
                  ? Container(
                      margin: EdgeInsets.only(top: 4, left: 12),
                      child: Text(
                        _upiAddrError,
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        // Fluttertoast.showToast(msg: "You can't change amount");
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 32),
                        color: Color.fromRGBO(93, 83, 207, 1),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _amountController,
                                enabled: true,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Amount",
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              Container(
                margin: EdgeInsets.only(top: 128, bottom: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: Text('Pay Using',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 18.0,
                          )),
                    ),
                    FutureBuilder<List<ApplicationMeta>>(
                      future: _appsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Container();
                        }

                        return GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.6,
                          physics: NeverScrollableScrollPhysics(),
                          children: snapshot.data
                              .map((it) => Material(
                                    key: ObjectKey(it.upiApplication),
                                    color: Colors.grey[200],
                                    child: InkWell(
                                      onTap: () => _onTap(it),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.memory(
                                            it.icon,
                                            width: 64,
                                            height: 64,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 4),
                                            child: Text(
                                              it.upiApplication.getAppName(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String _validateUpiAddress(String value) {
  if (value.isEmpty) {
    return 'UPI Address is required.';
  }

  if (!UpiPay.checkIfUpiAddressIsValid(value)) {
    return 'UPI Address is invalid.';
  }

  return null;
}
