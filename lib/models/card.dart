import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftcalculator/models/lift.dart';
import 'package:liftcalculator/models/profile.dart';
import 'package:provider/provider.dart';

class HomeCard {
  final String contentTitle;
  final Widget content;
  bool changeable;
  String imageName;

  HomeCard(this.contentTitle, this.content, this.imageName,
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
              children: [_.content],
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
                        title: const Text('Change exercise'),
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

Widget changeTrainingDialog(BuildContext context, StateSetter setState) {
  var profile = Provider.of<UserProfile>(context, listen: false);
  String? _trainingOption = profile.currentExercise.abbreviation;
  List<Widget> output = [];
  GLOBAL_ALL_LIFTS.forEach((e) {
    bool isCompleted = profile.cycleWeek.getLiftStatus(e.id);
    RadioListTile temp = RadioListTile<String>(
      title: !isCompleted
          ? Text(e.title)
          : Text(e.title,
              style: TextStyle(decoration: TextDecoration.lineThrough, decorationThickness: 2.85, color: Colors.grey)),
      value: e.abbreviation,
      groupValue: _trainingOption,
      onChanged: (String? value) {
        if (!isCompleted){
          setState(() {
          Provider.of<UserProfile>(context, listen: false)
              .storeUserSetting('Current_Exercise', e.id);
          _trainingOption = value;
          Navigator.pop(context, 'Saved');
        });
        }
      },
    );
    output.add(temp);
  });

  return Column(mainAxisSize: MainAxisSize.min, children: output);
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
