import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stateful App Example',
      home: Investor(),
    ));

class Investor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InvestorState();
  }
}

class _InvestorState extends State<Investor> {
  // passing a global key for our Form
  var _formKey = GlobalKey<FormState>();

  var _currencies = ['Naira', 'Dollar', 'Pounds', 'Euro', 'other'];
  var _currentItemSelected = 'Naira';

  // lets get the input data by doing:
  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  String displayResult = '';

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle2;

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Calculate your Interest'),
      ),
      body:
          //testing.....................
          Form(
        //passing the form key from our global state:
        key: _formKey,
        // color: Colors.yellow[100],
        child: ListView(
          children: <Widget>[
            new Image.asset(
              'images/money2.png',
              width: 420,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  controller: principalController,
                  // add a validator:
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter principal amount';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Principal',
                      labelStyle: textStyle,
                      errorStyle: TextStyle(fontSize: 15.0),
                      hintText: 'Enter Principal e.g. 12000')),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  controller: roiController,
                  // add a validator:
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter ROI amount';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Rate of Interest',
                      labelStyle: textStyle,
                      errorStyle: TextStyle(fontSize: 15.0),
                      hintText: 'In percent')),
            ),
            //Row for Term and dropdown
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      //this extracts the values from the text field
                      controller: termController,
                      // add validator:
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter term';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Term',
                          labelStyle: textStyle,
                          errorStyle: TextStyle(fontSize: 12.0),
                          hintText: 'Time in years'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    // creating a dropdown button :
                    child: DropdownButton<String>(
                      items: _currencies.map((String valueOne) {
                        return DropdownMenuItem<String>(
                            value: valueOne, child: Text(valueOne));
                      }).toList(),
                      onChanged: (String newValueSelected) {
                        _value(newValueSelected);
                      },
                      value: _currentItemSelected,
                    ),
                  ),
                )
              ],
            ),
            // Row for Button:
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Colors.blue,
                      elevation: 7.0,
                      child: Text(
                        'Calculate',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        //to calculate the numbers input:
                        setState(() {
                          if (_formKey.currentState.validate()) {
                            this.displayResult = _calculateTotalReturns();
                          }
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Colors.brown,
                      elevation: 7.0,
                      child: Text(
                        'Reset',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          _reset();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  this.displayResult,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _value(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  // function for calculating the input data
  String _calculateTotalReturns() {
    // because we are dealing with text we cannot simply make it work
    //so we have to parse it in the double parameter:
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;

    String result =
        'After $term years, your investment will be worth: $totalAmountPayable  $_currentItemSelected';

    return result;
  }

  void _reset() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';

    _currentItemSelected = _currencies[0];
  }
}
