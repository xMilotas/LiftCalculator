// ignore_for_file: implementation_imports

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:charts_flutter/src/text_element.dart' as chartsTextElement;
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:liftcalculator/models/selectedLift.dart';
import 'package:provider/provider.dart';
import 'dbLift.dart';
import 'package:intl/intl.dart';

class LiftChart extends StatefulWidget {
  final List<Series<dynamic, DateTime>> seriesList;
  final String liftTitle;
  final String selectedStat;
  final bool animate;
  final bool fullscreen;

  LiftChart(this.seriesList, this.liftTitle, this.selectedStat,
      {this.animate = true, this.fullscreen = false});

  // We need a Stateful widget to build the selection details with the current
  // selection as the state.
  @override
  State<StatefulWidget> createState() => new _SelectionCallbackState();
}

class _SelectionCallbackState extends State<LiftChart> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // The children consist of a Chart and Text widgets below to hold the info.
    final children = <Widget>[
      new SizedBox(
          height: (widget.fullscreen)
              ? MediaQuery.of(context).size.height * 0.8
              : 270.0,
          child: new TimeSeriesChart(
            widget.seriesList,
            animate: widget.animate,
            primaryMeasureAxis: new NumericAxisSpec(
              tickProviderSpec: BasicNumericTickProviderSpec(
                  desiredTickCount: (widget.fullscreen) ? 8 : 5),
              renderSpec: GridlineRendererSpec(
                  lineStyle: LineStyleSpec(
                    dashPattern: [4, 4],
                  ),
                  labelStyle: TextStyleSpec(color: MaterialPalette.white)),
            ),
            domainAxis: new DateTimeAxisSpec(
                tickProviderSpec: DayTickProviderSpec(increments: [9]),
                viewport: DateTimeExtents(
                    start: now.subtract(Duration(days: 30)), end: now),
                renderSpec: SmallTickRendererSpec(
                    labelStyle: TextStyleSpec(color: MaterialPalette.white))),
            behaviors: [
              new PanAndZoomBehavior(),
              new ChartTitle(widget.liftTitle,
                  titleStyleSpec: TextStyleSpec(color: MaterialPalette.white),
                  subTitle: (widget.selectedStat == '1RM')
                      ? 'Calculated 1RM'
                      : 'Max Weight',
                  subTitleStyleSpec:
                      TextStyleSpec(color: MaterialPalette.white, fontSize: 14),
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
    // String selectedStatsType =
    //     Provider.of<StatsSelectedLift>(context, listen: false)
    //         .selectedStatsType;

    var dateStyle = style.TextStyle();
    dateStyle.fontSize = 11;
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(selectedElement.date);

    final TextElement date =
        chartsTextElement.TextElement(formattedDate, style: dateStyle);

    String displayText = "";
    // if (selectedStatsType == '1RM') {
    //   displayText =
    //       '1RM: ${selectedElement.calculated1RM} kg via ${selectedElement.weightRep.toString()}';
    // }
    // if (selectedStatsType == 'Weight') {
    //   displayText = '${selectedElement.weightRep.toString()}';
    // }

    final TextElement weightReps = chartsTextElement.TextElement(displayText);
    canvas.drawText(weightReps, 150, 45);
    canvas.drawText(date, 190, 28);
  }
}
