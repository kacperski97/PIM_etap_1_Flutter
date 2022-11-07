import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main(){
  runApp(
    MaterialApp(
      title: 'Clicker App',
      initialRoute: '/',
      routes: {
        '/': (context) => const MainWidget(),
        '/shop': (context) => const ShopWidget(),
      },
    )
  );
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainWidgetState();
  }
}
class _MainWidgetState extends State<MainWidget>{
  var counter = 0;
  var buttonOneUnlocked = false;
  var buttonTwoUnlocked = false;
  var buttonThreeUnlocked = false;
  var buttonFourUnlocked = false;

  increaseCounter(int increase, bool lock){
    if(lock) {
      setState(() {
        counter = counter + increase;
      });
    }else{
      Fluttertoast.showToast(msg: 'To use this button buy it in a store first!', toastLength: Toast.LENGTH_SHORT);
    }
  }

  goToShop() async {
    final newArguments = await Navigator.pushNamed(context, '/shop', arguments: PassedArguments(counter,
        buttonOneUnlocked, buttonTwoUnlocked, buttonThreeUnlocked, buttonFourUnlocked)) as PassedArguments;

    setState(() {
      counter = int.parse(newArguments.score.toString());
    });

    if(newArguments.b1){
      setState(() {
        buttonOneUnlocked = true;
      });
    }

    if(newArguments.b2){
      setState(() {
        buttonTwoUnlocked = true;
      });
    }

    if(newArguments.b3){
      setState(() {
        buttonThreeUnlocked = true;
      });
    }

    if(newArguments.b4){
      setState(() {
        buttonFourUnlocked = true;
      });
    }
  }
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Clicker',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Clicker'),
        ),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Points: $counter'),
        TextButton(
            onPressed: (){increaseCounter(1, true);},
            child: Text('Button')
        ),TextButton(
            onPressed: (){increaseCounter(5, buttonOneUnlocked);},
            child: Text('Better Button')
        ),TextButton(
            onPressed: (){increaseCounter(10, buttonTwoUnlocked);},
            child: Text('Super Button')
        ),TextButton(
            onPressed: (){increaseCounter(50, buttonThreeUnlocked);},
            child: Text('Mega Button')
        ),TextButton(
            onPressed: (){increaseCounter(100, buttonFourUnlocked);},
            child: Text('Giga Button')
        ),TextButton(
            onPressed: goToShop,
            child: Text('Shop')
        ),
      ],
      ),)
      ),
    );
  }
}

class ShopWidget extends StatelessWidget {
  const ShopWidget({super.key});

  goToClicker(var context, int score, int cost, bool b1, bool b2, bool b3, bool b4, bool isBought) {
    if(isBought) {
      Fluttertoast.showToast(msg: 'Already bought',
          toastLength: Toast.LENGTH_SHORT);
    }else if(score < cost) {
      Fluttertoast.showToast(msg: 'Not enough points',
          toastLength: Toast.LENGTH_SHORT);
    }else{
        Navigator.pop(context, PassedArguments(score - cost, b1, b2, b3, b4));
    }
  }

  @override
  Widget build(BuildContext context){
    final arguments = ModalRoute.of(context)!.settings.arguments as PassedArguments;

    return MaterialApp(
      title: 'Shop',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Shop'),
          ),
          body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Points: ${arguments.score}'),
              TextButton(
                  onPressed: (){goToClicker(context, arguments.score, 25, true, false, false, false, arguments.b1);},
                  child: Text('Buy Better Button for 25 points')
              ),TextButton(
                  onPressed: (){goToClicker(context, arguments.score, 100, false, true, false, false, arguments.b2);},
                  child: Text('Buy Super Button for 100 points')
              ),TextButton(
                  onPressed: (){goToClicker(context, arguments.score, 1000, false, false, true, false, arguments.b3);},
                  child: Text('Buy Mega Button for 1000 points')
              ),TextButton(
                  onPressed: (){goToClicker(context, arguments.score, 5000, false, false, false, true, arguments.b4);},
                  child: Text('Buy Giga Button for 5000 points')
              ),TextButton(
                  onPressed: (){goToClicker(context, arguments.score, 0, false, false, false, false, false);},
                  child: Text('Return')
              ),
            ],
          ),)
      ),
    );
  }
}

class PassedArguments{
  final int score;
  final bool b1;
  final bool b2;
  final bool b3;
  final bool b4;

  PassedArguments(this.score, this.b1, this.b2, this.b3, this.b4);
}

