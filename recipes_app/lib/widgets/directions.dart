import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe_model.dart';

class Directions extends StatefulWidget {
  final RecipeModel recipeModel;
  const Directions({Key? key, required this.recipeModel}) : super(key: key);

  @override
  State<Directions> createState() => _DirectionsState();
}

class _DirectionsState extends State<Directions> {
  int currentStep = 0;
  List<Step> getSteps() {
    List<Step> steps = <Step>[];

    for (var element in widget.recipeModel.analyzedInstructions) {
      steps.add(Step(
          isActive: currentStep == element['number'] - 1,
          title: Text("${"step".tr} ${element['number']}"),
          content: Container(
              alignment: Alignment.centerLeft,
              child: Text(element['step'].toString()))));
    }

    return steps;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Stepper(
          controlsBuilder: (
            BuildContext context,
            ControlsDetails details,
          ) {
            return Row(
              children: <Widget>[
                currentStep + 1 < widget.recipeModel.analyzedInstructions.length
                    ? TextButton(
                        onPressed: () {
                          if (currentStep + 1 <
                              widget.recipeModel.analyzedInstructions.length) {
                            setState(() {
                              currentStep += 1;
                            });
                          }
                        },
                        child: Text("next_step".tr,
                            style: TextStyle(
                                color: Color.fromARGB(255, 100, 255, 218))),
                      )
                    : Text("next_step".tr,
                        style: TextStyle(color: Colors.grey)),
                currentStep > 0
                    ? TextButton(
                        onPressed: () {
                          if (currentStep > 0) {
                            setState(() {
                              currentStep -= 1;
                            });
                          }
                        },
                        child: Text("prev_step".tr,
                            style: TextStyle(
                                color: Color.fromARGB(255, 100, 255, 218))),
                      )
                    : Text("prev_step".tr,
                        style: TextStyle(color: Colors.grey)),
              ],
            );
          },
          currentStep: currentStep,
          steps: getSteps(),
        ));
  }
}
