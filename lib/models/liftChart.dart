import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:charts_flutter/src/text_element.dart' as chartsTextElement;
import 'package:liftcalculator/models/selectedLift.dart';
import 'package:provider/provider.dart';
import 'dbLift.dart';

class LiftChart extends StatefulWidget {
  final List<Series<dynamic, DateTime>> seriesList;
  final String liftTitle;
  final bool animate;

  LiftChart(this.seriesList, this.liftTitle, {this.animate = false});

  // We need a Stateful widget to build the selection details with the current
  // selection as the state.
  @override
  State<StatefulWidget> createState() => new _SelectionCallbackState();
}

class _SelectionCallbackState extends State<LiftChart> {
  @override
  Widget build(BuildContext context) {
    // The children consist of a Chart and Text widgets below to hold the info.
    final children = <Widget>[
      new SizedBox(
          height: 270.0,
          child: new TimeSeriesChart(
            widget.seriesList,
            animate: widget.animate,
            behaviors: [
              new ChartTitle(widget.liftTitle,
                  titleStyleSpec: TextStyleSpec(color: MaterialPalette.white),
                  subTitle: 'Calculated 1RM',
                  behaviorPosition: BehaviorPosition.top,
                  titleOutsideJustification: OutsideJustification.start,
                  innerPadding: 18),
              SelectNearest(
                  eventTrigger: SelectionTrigger.tapAndDrag,
                  selectClosestSeries: true),
              LinePointHighlighter(
                  radiusPaddingPx: 3.0,
                  showVerticalFollowLine:
                      LinePointHighlighterFollowLineType.nearest,
                  symbolRenderer:
                      MySymbolRenderer(MediaQuery.of(context).size, context)),
            ],
            selectionModels: [
              new SelectionModelConfig(
                type: SelectionModelType.info,
                changedListener: handleChange,
              )
            ],
          )),
    ];

    return new Column(children: children);
  }

  handleChange(SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    DbLift? selectedLift;
    if (selectedDatum.isNotEmpty) {
      selectedLift = selectedDatum.first.datum;
      print('SELECTION: ${model.selectedDatum.first.datum}');
      StatsSelectedLift selectorHelper =
          Provider.of<StatsSelectedLift>(context, listen: false);
      selectorHelper.changeLift(selectedLift!);
    }
  }
}

class MySymbolRenderer extends CircleSymbolRenderer {
  final Size size;
  BuildContext context;
  MySymbolRenderer(this.size, this.context);

  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
      Color? fillColor,
      FillPatternType? fillPattern,
      Color? strokeColor,
      double? strokeWidthPx}) {
    final center = Point(
      bounds.left + (bounds.width / 2),
      bounds.top + (bounds.height / 2),
    );
    final radius = min(bounds.width, bounds.height) / 2;
    canvas.drawPoint(
        point: center,
        radius: radius,
        fill: getSolidFillColor(fillColor),
        stroke: strokeColor,
        strokeWidthPx: getSolidStrokeWidthPx(strokeWidthPx));
    DbLift selectedElement =
        Provider.of<StatsSelectedLift>(context, listen: false).selectedLift;

    final TextElement textElement = chartsTextElement.TextElement(
        '${selectedElement.calculated1RM} kg via ${selectedElement.weightRep.toString()}');
    canvas.drawText(textElement, 150, 80);
  }
}
