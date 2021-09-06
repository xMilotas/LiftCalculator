import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftcalculator/models/profile.dart';
import 'package:provider/provider.dart';

class HomeCard {
  final String contentTitle;
  final String contentRow1;
  final String contentRow2;
  final String contentRow3;
  bool changeable;
  String imageName;

  HomeCard(this.contentTitle, this.contentRow1, this.contentRow2,
      this.contentRow3, this.imageName,
      {this.changeable = false});
}

/// A card that navigates to a specific route
class TappableCard extends StatelessWidget {
  final String sectionTitle;
  final HomeCard cartContent;
  final String route;

  TappableCard(
      {required this.sectionTitle,
      required this.cartContent,
      required this.route});

  static const height = 313.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            CardSectionTitle(sectionTitle),
            SizedBox(
              height: height,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  // Navigate to whatever route was passed in
                  onTap: () => Navigator.pushReplacementNamed(context, route),
                  splashColor:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                  highlightColor: Colors.transparent,
                  child: CardContent(cartContent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final HomeCard _;
  CardContent(this._);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.headline5!.copyWith(color: Colors.white);
    final descriptionStyle = theme.textTheme.subtitle1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 184,
          child: Stack(
            children: [
              Positioned.fill(
                // In order to have the ink splash appear above the image, you
                // must use Ink.image. This allows the image to be painted as
                // part of the Material and display ink effects above it. Using
                // a standard Image will obscure the ink splash.
                child: Ink.image(
                  image: AssetImage(_.imageName),
                  fit: BoxFit.cover,
                  child: Container(),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(_.contentTitle, style: titleStyle),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: DefaultTextStyle(
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: descriptionStyle!,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_.contentRow1),
                    Text(_.contentRow2),
                    Text(_.contentRow3),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_.changeable)
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
                icon: Icon(Icons.change_circle),
                color: Colors.white,
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Change excercise'),
                        content: StatefulBuilder(
                            builder: (context, setState) =>
                                changeTrainingDialog(context, setState)),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                        ],
                      );
                    })),
          )
      ],
    );
  }
}

enum TrainingOptions { OHP, DL, SQ, BP }
var mappingTable = {
  "Overhead Press": TrainingOptions.OHP,
  "Deadlift": TrainingOptions.DL,
  "Bench Press": TrainingOptions.BP,
  "Squat": TrainingOptions.SQ
};


Widget changeTrainingDialog(BuildContext context, StateSetter setState) {
  var profile = Provider.of<UserProfile>(context, listen: false);
  TrainingOptions? _trainingOption = mappingTable[profile.currentExcercise];

  return Column(mainAxisSize: MainAxisSize.min, children: 
    mappingTable.keys.map((e) =>
      RadioListTile<TrainingOptions>(
        title: Text(e.toString()),
        value: mappingTable[e]!,
        groupValue: _trainingOption,
        onChanged: (TrainingOptions? value) {
          setState(() {
            print(e);
            Provider.of<UserProfile>(context, listen: false).storeUserSetting('Current_Excercise', e);
            _trainingOption = value;
            Navigator.pop(context, 'Saved');
          });
        },
    )).toList()
  );
}

class CardSectionTitle extends StatelessWidget {
  final String title;
  CardSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: Theme.of(context).textTheme.headline6),
      ),
    );
  }
}
