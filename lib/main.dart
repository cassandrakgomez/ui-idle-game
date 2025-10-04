import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: IdleGame(),
  ));
}

class IdleGame extends StatefulWidget {
    const IdleGame({super.key});

    @override
    State<IdleGame> createState() => _IdleGameState();
  }

  class _IdleGameState extends State<IdleGame> {
    // Part 2, Click Upgrade
    var _clickPower = 1.0; 
    var _clickUpgradeLvl = 1.0; 
    var _clickUpgradeCost = 10.0; 
    // Part 2, Passive Income
    var _passiveIncome = 0.0; // resources gained per second
    int _passiveLvl = 0; // level of passive income
    var _passiveCost = 20.0; // cost to upgrade
    Timer? _passiveTimer; // timer increments     
    
    double _resource = 0.0; // the coffee! 

    @override
    void initState() {
      super.initState();

      _passiveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_passiveIncome > 0) {
          setState(() {
            _resource += _passiveIncome;
          });
        }
      });
    }

    @override
    void dispose() {
      _passiveTimer?.cancel();
      super.dispose();
    }


    void _collectResource() { // function to increment the resource by the level of power
      setState(() {
        _resource += _clickPower;
      });
    }

    void _upgradeClick() {
      if (_resource >= _clickUpgradeCost) {
        setState(() {
          _resource -= _clickUpgradeCost;
          _clickPower += 1;
          _clickUpgradeLvl += 1; 
          _clickUpgradeCost *= 2; // next cost will be doubled
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Not enough coffee to upgrade!')),
        );
      }
    }

    void _upgradePassive(){
      if (_resource >= _passiveCost) {
        setState(() {
          _resource -= _passiveCost; 
          _passiveLvl += 1; 
          _passiveIncome += 0.5; 
          _passiveCost *= 2; 
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Not enough coffee to hire a barista!')),
        );
      }
    }

    void _resetGame(){
      setState(() {
        _resource = 0.0;
        _clickPower = 1.0; 
        _clickUpgradeLvl = 1.0; 
        _clickUpgradeCost = 10.0; 
        _passiveIncome = 0.0; 
        _passiveLvl = 0; 
        _passiveCost = 20.0;
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Color(0xFFECCCA6),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_resource Coffee',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24), //spacing between text and button 
              // Click level text
              Text(
                'Machine Lvl: $_clickUpgradeLvl',
                style: const TextStyle(fontSize: 24),
              ),
              //passive income
              Text(
                '$_passiveLvl Baristas: $_passiveIncome/s',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 30),

              //Upgrade machine button (click upgrade)
              ElevatedButton(
                onPressed: _upgradeClick, 
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: Color(0xFF47748b),
                ),
                child: Text('Upgrade Machine ($_clickUpgradeCost Coffee)', style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
                const SizedBox(height: 8),

                // Passive Button 
                ElevatedButton(
                onPressed: _upgradePassive, 
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: Color(0xFF47748b),
                ),
                child: Text('Hire Barista ($_passiveCost Coffee)', style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
                const SizedBox(height: 40),

                // collect resource button
                ElevatedButton(
                onPressed: _collectResource,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 95, vertical: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Color.fromARGB(255, 182, 93, 68), // color for the button 
                ),
                child: const Text(
                  'BREW COFFEE',
                  style: TextStyle(fontSize: 30, color: Colors.white) // color for the button text
                )
              ),
              const SizedBox(height: 20),

              //reset game button
              const SizedBox(height: 16), 
              ElevatedButton(
                onPressed: _resetGame,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Color(0xFF27456c), // color for the button 
                ),
                child: const Text(
                  'Reset',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold))
                )
            ],
          )
        )
      );
    }
  }
